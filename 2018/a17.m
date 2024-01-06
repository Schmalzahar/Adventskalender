input = readlines("a17.txt");
tic
insp = input.split(', ');
ind = contains(insp(:,1),'x');
v = insp(ind,:);
r = []; c = [];
for i=1:height(v)
    l = v(i,:);
    yr = double(extract(l(2),digitsPattern))';
    y = (yr(1):yr(end))';
    x = double(extract(l(1),digitsPattern))';
    r = [r; y+1];
    c = [c; repelem(x,length(y),1)];
end
h = insp(~ind,:);
for j=1:height(h)
    l = h(j,:);
    xr = double(extract(l(2),digitsPattern))';
    x = (xr(1):xr(end))';
    y = double(extract(l(1),digitsPattern))';
    c = [c; x];
    r = [r; repelem(y+1,length(x),1)];
end
ymin = min(r)-1; ymax = max(r)+1; xmin = min(c)-1; xmax = max(c)+1;
map = zeros(ymax-ymin,xmax-xmin+1);
inds = sub2ind(size(map),1+r-ymin,1+c-xmin);
map(inds) = 1;
map(1,500-xmin+1) = 2;
toc
%% let it flow
tic
% 2: source, 3: water encountered. 4: standing water
pos_queue = [];
pos = [1, 500-xmin+1];
prev_starts = [];
end_reached = 0;
not_done = 1;
while not_done
    while true
        if pos(1) == height(map) || end_reached
            if isempty(pos_queue)
                % done
                fprintf('Part 1 result = %d\n',sum(map == 3,'all') + sum(map == 4,'all'))
                fprintf('Part 2 result = %d\n',sum(map == 4,'all'))
                not_done = 0;
                break
            end            
            while map(pos_queue(end,1),pos_queue(end,2)) ~= 3
                pos_queue(end,:) = [];                
            end
            pos = pos_queue(end,:); pos_queue(end,:) = [];
            end_reached = 0;
        end
        pos(1) = pos(1) + 1;
        switch map(pos(1),pos(2))
            case 0
                map(pos(1),pos(2)) = 3;
            case {1, 4}
                % try to expand left and right
                layer = map(pos(1)-1:pos(1),:);
                % range the water can occupy
                right_wall = pos(2) + find(layer(1,pos(2)+1:end) == 1,1,'first');
                r_hole = pos(2) + find(ismember(layer(2,(pos(2)+1):end),[0 3]),1,'first');
                left_wall = find(layer(1,1:pos(2)-1) == 1,1,'last');
                l_hole = find(ismember(layer(2,1:pos(2)),[0 3]),1,'last');
                if right_wall <= r_hole
                    r_hole = [];
                else
                    right_wall = [];
                end
                if left_wall >= l_hole
                    l_hole = [];
                else
                    left_wall = [];
                end                
                if isempty(l_hole) && isempty(r_hole)
                    % no hole, fill up with water
                    map(pos(1)-1,(left_wall+1):(right_wall-1)) = 4;
                    pos = [pos(1)-2 pos(2)]; % dont add to prev_starts
                    break
                end             
                if isempty(left_wall) && isempty(right_wall)
                    % will flow to both directions
                    map(pos(1)-1,l_hole:r_hole) = 3;
                    % continue on the left path and go down that path till
                    % the end. Then, go to the right path                    
                    pos_queue(end+1,:) = [pos(1)-1 r_hole];   
                    pos_queue = unique(pos_queue,'rows');
                    pos = [pos(1)-1 l_hole];                    
                elseif isempty(right_wall) && isempty(l_hole)
                    % flows to the right
                    map(pos(1)-1,(left_wall+1):r_hole) = 3;
                    pos = [pos(1)-1 r_hole];                    
                else
                    % flows to the left
                    map(pos(1)-1,(l_hole):(right_wall-1)) = 3;
                    pos = [pos(1)-1 l_hole];
                end
                if ~isempty(prev_starts) && ismember(pos, prev_starts,"rows")
                    end_reached = 1;
                    break
                end
                prev_starts(end+1,:) = pos;
                break
        end        
    end
    imagesc(map)  
    % focus map around current pos
    ylim([max(1,pos(1)-100) min(pos(1)+100,height(map))])
    xlim([max(1,pos(2)-100) min(pos(2)+100,width(map))])    
    % axis equal
end
toc