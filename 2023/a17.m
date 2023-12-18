input = char(readlines("a17.txt"));
pos = [1 1];
fin = [13 13];
% directions: up down right left: 1 2 3 4
pos = [pos 3 0]; % start dir 3, with 0 previous blocks in the same dir

[a,b] = find(input > 1);
unknown_knots = [a(2:end) b(2:end)];
% open_list = [pos sum(abs(fin-pos))];
closed_list = [];
g = Inf(size(input));
g(1,1) = 0;
cameFrom = containers.Map('KeyType','double','ValueType','double');

queue = PriorityQueue();
queue.push(pos, sum(abs(fin-pos(1:2))));

while ~queue.isEmpty()

    curr_node = queue.pop();
    pos = curr_node(1:2);
    pos_id = sub2ind(size(input),pos(1),pos(2));
    dir = curr_node(3);
    len = curr_node(4);
    if all(curr_node(1:2) == fin)
        path = reconstruct_path(cameFrom, curr_node);
        break
    end
    if all(pos == [1,5])
        test = 1;
    end

    closed_list = [closed_list; curr_node(1:2)];
    a = [queue.items{:}];
    if ~isempty(a)
        open_list = reshape([a.item],4,[])';
    else
        open_list = [0 0 0 0];
    end

    % at most three blocks in a single direction, then 90d turn.
    new_pos = [];
    if dir ~= 1 && ~(dir == 2 && len > 2) && pos(1) < height(input)
        if dir == 2
            new_pos = [new_pos;pos(1)+1 pos(2) dir len+1];
        else
            new_pos = [new_pos;pos(1)+1 pos(2) 2 1];
        end
    end
    if dir ~= 2 && ~(dir == 1 && len > 2) && pos(1) > 1
        if dir == 1
            new_pos = [new_pos;pos(1)-1 pos(2) dir len+1];
        else
            new_pos = [new_pos;pos(1)-1 pos(2) 1 1];
        end
    end
    if dir ~= 3 && ~(dir == 4 && len > 2) && pos(2) > 1
        if dir == 4
            new_pos = [new_pos;pos(1) pos(2)-1 dir len+1];
        else
            new_pos = [new_pos;pos(1) pos(2)-1 4 1];
        end

    end
    if dir ~= 4 && ~(dir == 3 && len > 2) && pos(2) < width(input)
        if dir == 3
            new_pos = [new_pos;pos(1) pos(2)+1 dir len+1];
        else
            new_pos = [new_pos;pos(1) pos(2)+1 3 1];
        end
    end

    for i=1:height(new_pos)
        if ismember(new_pos(i,1:2), closed_list, 'rows')
            continue
        end
        %todo
        % calculate costs
        tentative_g = g(curr_node(1), curr_node(2)) + str2double(input(new_pos(i,1),new_pos(i,2)));
        if ismember(new_pos(i,1:2), open_list(:,1:2), 'rows')...
                && tentative_g >= g(new_pos(i,1), new_pos(i,2))
            continue
        end
        % is the 3 step rule still acounted for?
%         its = queue.getItems;
        
        
        g(new_pos(i,1), new_pos(i,2)) = tentative_g;
        id = sub2ind(size(input),new_pos(i,1),new_pos(i,2));
        
        cameFrom(id) = pos_id;
        f = tentative_g + sum(abs(fin-new_pos(i,1:2)));
        if ismember(new_pos(i,1:2), open_list(:,1:2), 'rows')
%             queue.updateKey(new_pos(i,:), f);
        else
            queue.push(new_pos(i,:), f);
        end
    end
end


path_map = zeros(size(input));
path_map(path) = 1;
imagesc(path_map)

function out = reconstruct_path(cameFrom, current)    
    current_id = current(1)*current(2);
    out = current_id;
    while ismember(current_id,cell2mat(cameFrom.keys))
        current_id = cameFrom(current_id);
        out = [current_id, out];
    end
end



