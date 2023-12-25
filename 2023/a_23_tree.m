input = char(readlines("a23.txt"));
% alternate approach idea for part 2: build a tree with the crossroads as
% edges
start_loc = [1 2];
start_loc = sub2ind(size(input),start_loc(1),start_loc(2));
end_loc = [141 140];
end_loc = sub2ind(size(input),end_loc(1),end_loc(2));
crossings = start_loc;
tree = graph;
[tree, crossings] = findCrossings(input, tree, start_loc, start_loc, crossings);
i=2;
while i <= length(crossings)
    [tree, crossings] = findCrossings(input, tree, crossings(i), crossings(i), crossings);
    plot(tree)
    i = i+1;
end

figure()
p = plot(tree,'EdgeLabel',tree.Edges.Weight);
%% get the longest paths and go through these paths first
dmax = 0;
Pmax = {};
paths_start_fin = tree.allpaths(num2str(start_loc),num2str(end_loc),"MinPathLength",34);
edges = string(tree.Edges.EndNodes);
weights = string(tree.Edges.Weight);
for i=1:height(paths_start_fin)
    path = paths_start_fin{i};
    d = 0;
    for j=1:length(path)-1
        d = d + weights(all(ismember(edges,[path(j) path(j+1)]),2)).double();
    end
    if d > dmax
        dmax = d;
        Pmax = path;
        clf
        p = plot(tree,'EdgeLabel',tree.Edges.Weight);
        highlight(p,Pmax,'EdgeColor','r');
        test = 1;
    end
end
res = dmax - length(Pmax)+1

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

%%
function [tree, crossings] = findCrossings(input, tree, start_loc, start_name, crossings)
    visited = [];
    % build tree

    curr_node = start_loc;

    visited = curr_node;
    pos_moves = posMoves(input,curr_node);
    pos_moves = pos_moves(~ismember(pos_moves,visited));
    % there will be at most 4 possibilities, with one leading back to the
    % start. We have to do all here.
    for j=1:height(pos_moves)
        pm = pos_moves(j);
        while height(pm) == 1
            curr_node = pm;
            visited = [visited; curr_node];
            pm = posMoves(input,curr_node);
            pm = pm(~ismember(pm,visited));
        end
    
        % crossroad
        if ~ismember(curr_node,crossings)
            crossings = [crossings; curr_node];
            tree = addedge(tree,num2str(start_name),num2str(curr_node),length(visited));
        else
            % see wether edge between curr_node and start_loc already
            % exists
            ted = tree.Edges.EndNodes;
            if ~any(any(ismember(string(ted),num2str(curr_node)),2) & any(ismember(string(ted),num2str(start_loc)),2))
                tree = addedge(tree,num2str(start_name),num2str(curr_node),length(visited));
            end
            
        end
        visited = start_loc;
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