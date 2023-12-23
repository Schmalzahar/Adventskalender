input = char(readlines("a23.txt"));
% take the longest possible hike without going over the same tile twice
start_loc = [1 2];
end_loc = [141 140];

queue = PriorityQueue();
queue.push(sub2ind(size(input),start_loc(1),start_loc(2)), 0);
lengths = dijkstra(queue, input, []);
max(lengths)


function out = dijkstra(queue, input, visited)
    curr_node = queue.pop();
    out = [];
    % if curr_node == sub2ind(size(input),23,22)
    if curr_node == sub2ind(size(input),141,140)
        out = length(visited);
        return
    end
    visited = [visited; curr_node];
    pos_moves = posMoves(input,curr_node);
    pos_moves = pos_moves(~ismember(pos_moves,visited));
    while height(pos_moves) == 1
        curr_node = pos_moves;
        % if curr_node == sub2ind(size(input),23,22)
        if curr_node == sub2ind(size(input),141,140)
            out = length(visited);
            return
        end
        % [a,~] = ind2sub(size(input),visited(mod(visited,height(input)) == 140));
        a = find(mod(visited,height(input)) == 140,1);
        if ~isempty(a)
            b = find(mod(visited,height(input)) == 2);
            b = b(b>a);
            if ~isempty(b)                
                c = b(1);
                [~,cc] = ind2sub(size(input),visited(c));
                if ~isempty(c)
                    % now we have been at the top and at the bottom, from
                    % this point on, we cannot go left of the path we
                    % visited, or else we are trapped. First we need the
                    % right-most col in each row.
                    if ~exist('ccm','var')
                        ccm = zeros(height(input)-2,1);
                        for r=2:140
                            [~,ccc] = ind2sub(size(input),visited(mod(visited,height(input)) == r));
                            ccm(r-1) = max(ccc);
                        end
                        %ccm is the right-most collumn visited for rows 2 to
                        %height-1.
                    end
                    [cr,cc] = ind2sub(size(input), curr_node);
                    try
                        if ccm(cr-1)>cc
                            test = 1;
                        end
                    catch
                        test = 1;
                    end
                end
            end
        end
        visited = [visited; curr_node];
        pos_moves = posMoves(input,curr_node);
        pos_moves = pos_moves(~ismember(pos_moves,visited));

    end
    [r,c] = ind2sub(size(input),pos_moves);
    test = input;
    test(visited) = 'l';
    imagesc(test-0)
    for i=1:height(pos_moves)
        queue.push(pos_moves(i,:),numel(input)-(abs(r(i)-1)+abs(c(i)-1)));
        tout = dijkstra(queue, input, visited);
        out = [out;tout];
    end
    
    
end
    

function pos = posMoves(input, loc)
    test = 1;
    if length(loc) == 1
        [r,c] = ind2sub(size(input),loc);
        loc = [r c];
    end
    out = [loc(1)+1 loc(2); loc(1)-1 loc(2); loc(1) loc(2)+1; loc(1) loc(2)-1];
    pos = [];
    part = 2;
    if part == 1
        try 
            if ismember(input(out(1,1),out(1,2)),[".","v"])
                pos = [pos; out(1,1) out(1,2)];
            end
        catch ME
            if ~strcmp(ME.identifier,'MATLAB:badsubscript')
                rethrow(ME)
            end            
        end
        try 
            if ismember(input(out(2,1),out(2,2)),[".","^"])
                pos = [pos; out(2,1) out(2,2)];
            end
        catch ME
            if ~strcmp(ME.identifier,'MATLAB:badsubscript')
                rethrow(ME)
            end 
        end
        try 
            if ismember(input(out(3,1),out(3,2)),[".",">"])
                pos = [pos; out(3,1) out(3,2)];
            end
        catch ME
            if ~strcmp(ME.identifier,'MATLAB:badsubscript')
                rethrow(ME)
            end 
        end
        try 
            if ismember(input(out(4,1),out(4,2)),[".","<"])
                pos = [pos; out(4,1) out(4,2)];
            end
        catch ME
            if ~strcmp(ME.identifier,'MATLAB:badsubscript')
                rethrow(ME)
            end 
        end
        pos = sub2ind(size(input),pos(:,1),pos(:,2));
    else
        out = out(all((out > 0) & out <= size(input,1),2),:);
        out = sub2ind(size(input),out(:,1),out(:,2));
        pos = out(input(out) ~= '#');
    end
end


