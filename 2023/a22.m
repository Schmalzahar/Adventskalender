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
xvv = [xv repelem("x",height(xv),1)];
xvv = num2cell([xv repelem("x",height(xv),1)],2);
yv = split(sprintf("y%d,",1:height(y_block)),',');
yvv = num2cell([yv repelem("y",height(yv),1)],2);
zv = split(sprintf("z%d,",1:height(z_block)),',');
zvv = num2cell([zv repelem("z",height(zv),1)],2);
x_blocks = dictionary(xv(1:end-1), cellfun(@(x) permute(x,[3 2 1])', num2cell(x_block,[3 2]), 'UniformOutput', false));
y_blocks = dictionary(yv(1:end-1), cellfun(@(x) permute(x,[3 2 1])', num2cell(y_block,[3 2]), 'UniformOutput', false));
z_blocks = dictionary(zv(1:end-1), cellfun(@(x) permute(x,[3 2 1])', num2cell(z_block,[3 2]), 'UniformOutput', false));

blocks = dictionary([x_blocks.keys;y_blocks.keys;z_blocks.keys],[x_blocks.values;y_blocks.values;z_blocks.values]);

blocktype = dictionary((1:height(input)),[xvv(1:end-1);yvv(1:end-1);zvv(1:end-1)]');
toc
%% put them in the map
for i=1:height(input)
    b = blocks{blocktype{i}(1)};
    map((b(1,1):b(1,2))+1,(b(2,1):b(2,2))+1,(b(3,1):b(3,2))) = i;
end
[map, blocks, ~] = letthemFall(map, blocks, blocktype);
toc
%% save to disintegrate?
res = 0;
save_bricks = [];
for i=1:height(input)    
    inds = find(map == i);
    % check layer above
    if strcmp(blocktype{i}(2),"z")
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
        if ~strcmp(blocktype{block_ab}(2),'z') % z blocks are never save
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
    [~,~, falling_bricks{i}] = letthemFall(t_map, blocks, blocktype);
end
sum(cellfun(@(x)length(unique(x)),falling_bricks))
toc

function [map, blocks, falling_bricks] = letthemFall(map, blocks, blocktype)
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
            d = z-1;
            while true
                dl = map(:,:,d);
                dlocc = dl>0;
                ol = dlocc & occ;
                if ~any(ol,'all')
                    % path free, update map and occ
                    t = reshape([blocktype{bil}],2,[]);
                    rest = bil(t(2,:) ~= "z");
                    l = l .* ismember(l,rest);
                    if all(map(:,:,d-1) == 0,"all")
                        dd = d;
                        while all(map(:,:,dd) == 0,"all")
                            dd = dd - 1;
                            map(:,:,dd) = map(:,:,dd) + l;
                            map(:,:,d+1) = map(:,:,d+1) - l; 
                        end
                    else
                        map(:,:,d) = map(:,:,d) + l;
                        map(:,:,d+1) = map(:,:,d+1) - l; 
                    end
                    zbil = bil(t(2,:) == "z");                    
                    for zb = zbil' % z blocks moving down
                        bloc = blocks{blocktype{zb}(1)};
                        map((bloc(1,1):bloc(1,2))+1,(bloc(2,1):bloc(2,2))+1,(bloc(3,1):bloc(3,2))) = 0;
                        blocks{blocktype{zb}(1)}(3,:) = blocks{blocktype{zb}(1)}(3,:) - 1;
                        bloc = blocks{blocktype{zb}(1)};
                        map((bloc(1,1):bloc(1,2))+1,(bloc(2,1):bloc(2,2))+1,(bloc(3,1):bloc(3,2))) = zb;
                    end                    
                    falling_bricks = unique([falling_bricks bil']);
                    l = map(:,:,d);
                    bil = unique(l(l>0));
                    while isempty(bil)
                        d = d-1;
                        l = map(:,:,d);
                        bil = unique(l(l>0));
                    end
                    nbil = numel(bil);
                    occ = l > 0;
                elseif nbil > 1
                    % maybe partially blocked
                    % check if every block is blocked
                    moved = false;
                    for b = bil'
                        if ~any((l == b) & dlocc,'all')
                            % block can move
                            if strcmp(blocktype{b}(2),"z")
                                bloc = blocks{blocktype{b}(1)};
                                map((bloc(1,1):bloc(1,2))+1,(bloc(2,1):bloc(2,2))+1,(bloc(3,1):bloc(3,2))) = 0;
                                blocks{blocktype{b}(1)}(3,:) = blocks{blocktype{b}(1)}(3,:) - 1;
                                bloc = blocks{blocktype{b}(1)};
                                map((bloc(1,1):bloc(1,2))+1,(bloc(2,1):bloc(2,2))+1,(bloc(3,1):bloc(3,2))) = b;
                            else                    
                                map(:,:,d) = map(:,:,d) + l .* (l == b);
                                map(:,:,d+1) = map(:,:,d+1) -l .* (l == b);
                            end
                            falling_bricks = [falling_bricks b];
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
                d = d-1;
                if d < 1
                    break
                end
            end
    end
end