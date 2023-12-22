input = readlines("a22.txt").split('~').split(',').double;
tic
%JENGA!!
block_type = input(:,1,:) ~= input(:,2,:);
x_block = input(block_type(:,:,1),:,:);
y_block = input(block_type(:,:,2),:,:);
z_block = input(block_type(:,:,3),:,:);
% single cube blocks get added to z
single_cube = input((input(:,1,1) == input(:,2,1)) & (input(:,1,2) == input(:,2,2)) & (input(:,1,3) == input(:,2,3)),:,:);
z_block = [z_block; single_cube];
map = zeros(max(input(:,:,1),[],'all')-min(input(:,:,1),[],'all')+1, ...
    max(input(:,:,2),[],'all')-min(input(:,:,2),[],'all')+1, ...
    max(input(:,:,3),[],'all')-min(input(:,:,3),[],'all')+1);
xv = split(sprintf("x%d,",1:height(x_block)),',');
yv = split(sprintf("y%d,",1:height(y_block)),',');
zv = split(sprintf("z%d,",1:height(z_block)),',');
x_blocks = dictionary(xv(1:end-1), cellfun(@(x) permute(x,[3 2 1])', num2cell(x_block,[3 2]), 'UniformOutput', false));
y_blocks = dictionary(yv(1:end-1), cellfun(@(x) permute(x,[3 2 1])', num2cell(y_block,[3 2]), 'UniformOutput', false));
z_blocks = dictionary(zv(1:end-1), cellfun(@(x) permute(x,[3 2 1])', num2cell(z_block,[3 2]), 'UniformOutput', false));

blocks = dictionary([x_blocks.keys;y_blocks.keys;z_blocks.keys],[x_blocks.values;y_blocks.values;z_blocks.values]);

blocktype = dictionary((1:height(input)),[xv(1:end-1);yv(1:end-1);zv(1:end-1)]');


%% put them in the map
for i=1:height(input)
    b = blocks{blocktype(i)};
    map((b(1,1):b(1,2))+1,(b(2,1):b(2,2))+1,(b(3,1):b(3,2))) = i;
end
[map, ~] = letthemFall(map, blocktype);
%% save to disintegrate?
res = 0;
save_bricks = [];
for i=1:height(input)    
    inds = find(map == i);
    % check layer above
    if contains(blocktype(i),'z')
        inds_ab = inds(end)+size(map,1)*size(map,2);
    else
        inds_ab = inds+size(map,1)*size(map,2);
    end    
    blocks_ab = unique(map(inds_ab(map(inds_ab)>0)));
    % would the blocks_ab fall if removed?
    save = zeros(size(blocks_ab));
    for j = 1:height(blocks_ab)
        block_ab = blocks_ab(j);
        t_map = map;
        t_map(t_map == i) = 0;
        if ~contains(blocktype(block_ab),'z') % z blocks are never save
            b_ab_ind = find(t_map == block_ab);
            below_b_ab_ind = b_ab_ind - size(map,1)*size(map,2);
            if any(t_map(below_b_ab_ind)>0) % block is supported
                save(j) = 1;
            end
        end
    end
    if all(save) % block i is save to disintegrate
        res = res + 1;
        save_bricks = [save_bricks; i];
    end
end
res

%% part 2
unsave_bricks = (1:height(input))';
unsave_bricks(save_bricks) = [];
% check how many bricks would fall if an unsave brick would be removed
falling_bricks = cell(size(unsave_bricks,1),1);
for i=1:height(unsave_bricks)
    br = unsave_bricks(i);
    ind = find(map == br);
    t_map = map;
    t_map(ind) = 0;
    [~, falling_bricks{i}] = letthemFall(t_map, blocktype);
end
sum(cellfun(@length,falling_bricks))
toc

function [map, falling_bricks] = letthemFall(map, blocktype)
    falling_bricks = [];
    for z=2:size(map,3)
            l = map(:,:,z); % layer
            if all(l == 0,'all')
                continue
            end
            bil = unique(l(l>0)); % blocks in layer
            nbil = numel(bil);
            occ = l > 0;
            % look down
            for d=z-1:-1:1
                dl = map(:,:,d);
                dlocc = dl>0;
                ol = dlocc & occ;
                if ~any(ol,'all')
                    % path free, update map and occ
                    if any(contains(blocktype(bil),'z'))
                        % move all coords of the z block down
                        zbil = bil(contains(blocktype(bil),'z'));
                        for zb = zbil'
                            inds = find(map == zb);
                            map(inds) = 0;
                            map(inds-size(map,1)*size(map,2)) = zb;
                        end
                        rest = bil(~contains(blocktype(bil),'z'));
                        l = l .* ismember(l,rest);             
                    end
                    map(:,:,d) = map(:,:,d) + l;
                    map(:,:,d+1) = map(:,:,d+1) - l; 
                    falling_bricks = unique([falling_bricks bil']);
                    l = map(:,:,d);
                    bil = unique(l(l>0));
                    nbil = numel(bil);
                    occ = l > 0;
                elseif nbil > 1
                    % maybe partially blocked
                    % check if every block is blocked
                    moved = false;
                    for b = bil'
                        if ~any((l == b) & dlocc,'all')
                            % block can move
                            if contains(blocktype(b),'z')
                                inds = find(map == b);
                                map(inds) = 0;
                                map(inds-size(map,1)*size(map,2)) = b;
                            else                    
                                map(:,:,d) = map(:,:,d) + l .* (l == b);
                                map(:,:,d+1) = map(:,:,d+1) -l .* (l == b);
                            end
                            falling_bricks = unique([falling_bricks b]);
                            moved = true;
                        end                
                    end
                    if ~moved
                        break
                    else
                        l = map(:,:,d);
                        bil = unique(l(l>0));
                        nbil = numel(bil);
                        occ = l > 0;
                    end
                else
                    break
                end
            end
    end
end