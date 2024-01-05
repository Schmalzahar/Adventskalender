input = readlines("a17.txt");

insp = input.split(', ');
v = insp(contains(insp(:,1),'x'),:);
r = []; c = [];
for i=1:height(v)
    l = v(i,:);
    yr = double(extract(l(2),digitsPattern))';
    y = (yr(1):yr(end))';
    x = double(extract(l(1),digitsPattern))';
    r = [r; y+1];
    c = [c; repelem(x,length(y),1)];
end
h = insp(contains(insp(:,1),'y'),:);
for j=1:height(h)
    l = h(j,:);
    xr = double(extract(l(2),digitsPattern))';
    x = (xr(1):xr(end))';
    y = double(extract(l(1),digitsPattern))';
    c = [c; x];
    r = [r; repelem(y+1,length(x),1)];
end
ymin = 1; ymax = max(r)+1; xmin = min(c)-1; xmax = max(c)+1;

map = zeros(ymax-ymin,xmax-xmin+1);
inds = sub2ind(size(map),1+r-ymin,1+c-xmin);
map(inds) = 1;
map(1,500-xmin+1) = 2;

%% let it flow
% 2: source, 3: water encountered. 4: standing water
pos_queue = [];
start_pos = [1, 500-xmin+1];
branch = false;
while true
    % create one square meter of water
    % try to run down
    if isempty(pos_queue)
        pos = start_pos; % source
    else
        if size(pos_queue,1) == 1 && ~branch
            start_pos = pos_queue;
            pos_queue(1,:) = [];
            pos = start_pos;
        else
            branch = true;
            pos = pos_queue(1,:);
            pos_queue(1,:) = [];
        end
    end
    while true
        pos(1) = pos(1) + 1;
        if ~isempty(pos_queue) && ismember(pos,pos_queue,"rows")
            test = 1;
        end
        if pos(1) > height(map)
            break
        end
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
                if right_wall < r_hole
                    r_hole = [];
                end
                if left_wall > l_hole
                    l_hole = [];
                end
                if r_hole < right_wall
                    right_wall = [];
                end
                if l_hole > left_wall
                    left_wall = [];
                end
                
                % no hole and 2 walls: standing water
                if isempty(l_hole) && isempty(r_hole) && ~isempty(left_wall) && ~isempty(right_wall)
                    % no hole, fill up with water
                    map(pos(1)-1,(left_wall+1):(right_wall-1)) = 4;
                    break
                end
                % is there a hole in the bottom? If yes, no standing water,
                % but instead flow there
                if isempty(left_wall) && isempty(right_wall)
                    % will flow to either direction
                    map(pos(1)-1,l_hole:r_hole) = 3;
                    pos_queue(end+1,:) = [pos(1)-1 l_hole];
                    pos_queue(end+1,:) = [pos(1)-1 r_hole];
                    break
                elseif isempty(right_wall) && isempty(l_hole)
                    % flows to the right
                    map(pos(1)-1,(left_wall+1):r_hole) = 3;
                    new_pos = [pos(1)-1 r_hole];
                    if ~isempty(pos_queue) && ismember(new_pos,pos_queue,"rows")
                        branch = false;
                    else
                        pos_queue(end+1,:) = new_pos;
                    end                    
                    break
                elseif isempty(left_wall) && isempty(r_hole)
                    map(pos(1)-1,(l_hole):(right_wall-1)) = 3;
                    new_pos = [pos(1)-1 l_hole];
                    if ~isempty(pos_queue) && ismember(new_pos,pos_queue,"rows")
                        branch = false;
                    else
                        pos_queue(end+1,:) = new_pos;
                    end    
                    break
                else
                    ot = 1;
                end
                % if any(layer(2,(left_wall+1):(right_wall-1)) == 0) ...
                %         || any(layer(2,(left_wall+1):(right_wall-1)) == 3)
                % if any(ismember(layer(2,(left_wall+1):(right_wall-1)),[0 3]))
                %     r_hole = pos(2) + find(ismember(layer(2,(pos(2)+1):(right_wall-1)),[0 3]),1,'first');
                %     l_hole = find(ismember(layer(2,1:pos(2)),[0 3]),1,'last');
                %     if l_hole < left_wall
                %         l_hole = [];
                %     end
                %     if r_hole > right_wall
                %         r_hole = [];
                %     end
                %     if isempty(l_hole) && ~isempty(r_hole)
                %         % fill from the wall to r_hole
                %         layer(1,(left_wall+1):r_hole) = 3;
                %         map(pos(1)-1:pos(1),:) = layer;
                %         % continue at the hole position
                %         % pos = [pos(1)-1 r_hole];
                %         pos_queue(end+1,:) = [pos(1)-1 r_hole];
                %         break
                %     else
                %         todo = 1;
                %     end
                % 
                % 
                % 
                % else
                %     % no hole, fill up with water
                %     layer(1,(left_wall+1):(right_wall-1)) = 4;
                %     map(pos(1)-1:pos(1),:) = layer;
                %     break
                % end
        end
        
    end
    imagesc(map)  
    ylim([1 200])
    xlim([120 290])
    
    % axis equal
end



