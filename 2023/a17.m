input = char(readlines("a17.txt"));
pos = [1 1];
fin = [13 13];
% directions: up down right left: 1 2 3 4
pos = [pos 3]; % start dir 3, with 0 previous blocks in the same dir

[a,b] = find(input > 1);
unknown_knots = [a(2:end) b(2:end)];
% open_list = [pos sum(abs(fin-pos))];
closed_list = [];
g = Inf(size(input));
g(1,1) = 0;
came From = dictionary;

queue = PriorityQueue();
queue.push(pos, sum(abs(fin-pos(1:2))));

while ~queue.isEmpty()

    curr_node = queue.pop();
    pos = curr_node(1:2);
    pos_id = sub2ind(size(input),pos(1),pos(2));
    dir = curr_node(3);
    % len = curr_node(4);
    if all(curr_node(1:2) == fin)
        path = reconstruct_path(cameFrom, curr_node, size(input));
        break
    end
    if all(pos == [2,4])
        test = 1;
    end

    closed_list = [closed_list; curr_node(1:2)];
    a = [queue.items{:}];
    if ~isempty(a)
        open_list = reshape([a.item],3,[])';
    else
        open_list = [0 0 0 0];
    end

    % at most three blocks in a single direction, then 90d turn.
    new_pos = [];
    % if dir ~= 1 && ~(dir == 2 && len > 2) && pos(1) < height(input)
    if dir ~= 1 && pos(1) < height(input)
        new_pos = [new_pos;pos(1)+1 pos(2) 2];
    end
    % if dir ~= 2 && ~(dir == 1 && len > 2) && pos(1) > 1
    if dir ~= 2 && pos(1) > 1
        new_pos = [new_pos;pos(1)-1 pos(2) 1];
    end
    % if dir ~= 3 && ~(dir == 4 && len > 2) && pos(2) > 1
    if dir ~= 3 && pos(2) > 1
        new_pos = [new_pos;pos(1) pos(2)-1 4];
    end
    % if dir ~= 4 && ~(dir == 3 && len > 2) && pos(2) < width(input)
    if dir ~= 4 && pos(2) < width(input)
        new_pos = [new_pos;pos(1) pos(2)+1 3];
    end

    % every point should have g values for the 4 directions possible and
    % for the length of the current straight line. A g value that is higher
    % might still lead to the shortest overall path if the current straight
    % line is shorter. Thus there are two cases for each direction: either
    % a smaller g value (but possibly longer line) or a higher g value but
    % shorter line.



    % is the 3 step rule still acounted for?
    last_three = reconstruct_last_3(cameFrom, curr_node, size(input));
    [r,c] = ind2sub(size(input),last_three);
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
        
        if length(last_three) > 3
            r_i = [r, new_pos(i,1)];
            c_i = [c, new_pos(i,2)];
            % max 4 equal vals in r_i or c_i
            if (sum(r_i == mode(r_i)) == 5) || (sum(c_i == mode(c_i)) == 5)
                continue
            end
        end
        
        g(new_pos(i,1), new_pos(i,2)) = tentative_g;
        id = sub2ind(size(input),new_pos(i,1),new_pos(i,2));
        
        cameFrom(id) = pos_id;
        f = tentative_g + sum(abs(fin-new_pos(i,1:2)));
        if ismember(new_pos(i,1:2), open_list(:,1:2), 'rows')
            queue.updateKey(new_pos(i,:), f);
        else
            queue.push(new_pos(i,:), f);
        end
    end
end


path_map = zeros(size(input));
path_map(path) = 1;
imagesc(path_map)
sum(input(path(2:end))-48)

function out = reconstruct_path(cameFrom, current, sz)    
    current_id = sub2ind(sz,current(1), current(2));
    out = current_id;
    while ismember(current_id,cameFrom.keys)
        current_id = cameFrom(current_id);
        out = [current_id, out];
    end
end

function out = reconstruct_last_3(cameFrom, current, sz)
    current_id = sub2ind(sz,current(1), current(2));
    out = current_id;
    if isConfigured(cameFrom)
        for i=1:3
            if ismember(current_id,cameFrom.keys)
                current_id = cameFrom(current_id);
                out = [current_id, out];
            else
                break
            end
        end
    end
end