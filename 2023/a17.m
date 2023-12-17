input = char(readlines("a17.txt"));
pos = [1 1];
fin = [13 13];
% directions: up down right left: 1 2 3 4
pos = [pos 3 0]; % start dir 3, with 0 previous blocks in the same dir

[a,b] = find(input > 1);
unknown_knots = [a(2:end) b(2:end)];
% open_list = [pos sum(abs(fin-pos))];
closed_list = [];

queue = PriorityQueue();
queue.push(pos, sum(abs(fin-pos(1:2))));

while ~queue.isEmpty()

    curr_node = queue.pop();
    dir = curr_node(3);
    len = curr_node(4);
    if all(curr_node(1:2) == fin)
        break
    end

    closed_list = [closed_list; curr_node(1:2)];

    % at most three blocks in a single direction, then 90d turn.
    new_pos = [];
    if dir ~= 1 && ~(dir == 2 && len > 3) && pos(1) < height(input)
        if dir == 2
            new_pos = [new_pos;pos(1)+1 pos(2) dir len+1];
        else
            new_pos = [new_pos;pos(1)+1 pos(2) 2 1];
        end
    end
    if dir ~= 2 && ~(dir == 1 && len > 3) && pos(1) > 1
        if dir == 1
            new_pos = [new_pos;pos(1)-1 pos(2) dir len+1];
        else
            new_pos = [new_pos;pos(1)-1 pos(2) 1 1];
        end
    end
    if dir ~= 3 && ~(dir == 4 && len > 3) && pos(2) > 1
        if dir == 4
            new_pos = [new_pos;pos(1) pos(2)-1 dir len+1];
        else
            new_pos = [new_pos;pos(1) pos(2)-1 4 1];
        end

    end
    if dir ~= 4 && ~(dir == 3 && len > 3) && pos(2) < width(input)
        if dir == 3
            new_pos = [new_pos;pos(1) pos(2)+1 dir len+1];
        else
            new_pos = [new_pos;pos(1) pos(2)+1 3 1];
        end
    end

    for i=1:height(new_pos)
        if ismember(new_pos(1:2), closed_list, 'rows')
            continue
        end
        %todo
    end





end



