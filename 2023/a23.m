input = char(readlines("a23.txt"));
% take the longest possible hike without going over the same tile twice
start_loc = [1 2];
end_loc = [141 140];

%%
path = visualizePath(input, string(Pmax));
res = length(path)-1
function visited = visualizePath(input, P)
    curr_node = P(1).double;
    visited = curr_node;
    pos_moves = posMoves(input, curr_node);
    pos_moves = pos_moves(~ismember(pos_moves, visited));
    while height(pos_moves) == 1
        curr_node = pos_moves;
        visited = [visited; curr_node];
        pos_moves = posMoves(input, curr_node);
        pos_moves = pos_moves(~ismember(pos_moves,visited));
    end
    test = input;
    test(visited) = 'l';
    imagesc(test-0)
    test = 1;
    % i = 2;
    for i=2:(length(P)-1)
        % to to next crossing. There will be at most 3 options here
        next_P = P(i+1).double;
        paths = cell(height(pos_moves),1);
        for j=1:height(pos_moves)
            temp_visited = visited;
            temp_curr_node = pos_moves(j);
            temp_visited = [temp_visited; temp_curr_node];
            temp_pos_moves = posMoves(input, temp_curr_node);
            temp_pos_moves = temp_pos_moves(~ismember(temp_pos_moves, temp_visited));
            while height(temp_pos_moves) == 1
                temp_curr_node = temp_pos_moves;
                temp_visited = [temp_visited; temp_curr_node];
                temp_pos_moves = posMoves(input, temp_curr_node);
                temp_pos_moves = temp_pos_moves(~ismember(temp_pos_moves, temp_visited));            
            end
            if temp_curr_node == next_P
                % correct branch
                visited = temp_visited;
                curr_node = temp_curr_node;
                pos_moves = temp_pos_moves;
                break
            end                  
        end
        test = input;
        test(visited) = 'l';
        imagesc(test-0)
    end
end


function pos = posMoves(input, loc)
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