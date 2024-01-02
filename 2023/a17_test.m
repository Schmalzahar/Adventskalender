input = char(readlines("a17.txt"))-48;
input = input(1:5,1:5);
pos = [1 1];
pos = sub2ind(size(input),pos(1),pos(2));
fin = [5 5];
fin = sub2ind(size(input),fin(1),fin(2));
pos = [pos 3];
% directions: up down right left: 1 2 3 4
% [a,b] = find(input >= 1);
temp = find(input >= 1);
unknown_knots.a = [temp(2:end)];
unknown_knots.b = [temp(2:end)];
unknown_knots.c = [temp(2:end)];

known_knots.a = [];
known_knots.b = [];
known_knots.c = [];

shortest_paths.a = dictionary;
shortest_paths.b = dictionary;
shortest_paths.c = dictionary;

% cameFrom = dictionary;

out = testFun(input, pos, fin, known_knots, unknown_knots, [], shortest_paths);


function [known_knots, unknown_knots, cameFrom, shortest_paths] = testFun(input, curr_node, fin_pos, known_knots, unknown_knots, cameFrom, shortest_paths)
    curr_pos = curr_node(1);
    dir = curr_node(2);
    neighs = getNeigh(input, curr_pos, dir);
    for i=1:height(neighs)
        test = 1;
        if isempty(cameFrom)
            % we make the first step        
            inda = all(neighs(i,1) == unknown_knots.a,2);
            if any(inda)
                unknown_knots.a(inda,:) = [];
                if ~isempty(known_knots.a)
                    kk = known_knots.a{:};
                    ind2a = all(neighs(i,1) == kk(:,1),2);
                    if ind2a
                        test = 1;                        
                    else
                        known_knots.a = {[kk;neighs(i,:) input(neighs(i,1))]};
                        shortest_paths.a(neighs(i,1)) = {[curr_node(1) neighs(i,1)]};
                    end
                else
                    known_knots.a = {[neighs(i,:) input(neighs(i,1))]}; % inc,lastdir,cost
                    
                    shortest_paths.a(neighs(i,1)) = {[curr_node(1) neighs(i,1)]};
                end

            else

            end
        else
            test = 1;
        end
        % ok, so now make the next step
        curr_nodes = neighs;
        for i=1:height(curr_nodes)
            [known_knots, unknown_knots, cameFrom, shortest_paths] = testFun(input, curr_nodes(i,:), fin_pos, known_knots, unknown_knots, cameFrom, shortest_paths)
        end
    

    end

    out = [];
end

function neigh = getNeigh(input, pos, dir)
    if length(pos) == 1
        [r,c] = ind2sub(size(input),pos);
        pos = [r c];
    end
    neigh = [];
    if dir ~= 1 && pos(1) < height(input)
        neigh = [neigh;pos(1)+1 pos(2) 2];
    end
    if dir ~= 2 && pos(1) > 1
        neigh = [neigh;pos(1)-1 pos(2) 1];
    end
    if dir ~= 3 && pos(2) > 1
        neigh = [neigh;pos(1) pos(2)-1 4];
    end
    if dir ~= 4 && pos(2) < width(input)
        neigh = [neigh;pos(1) pos(2)+1 3];
    end
    neigh_pos = neigh(:,3);
    neigh = sub2ind(size(input),neigh(:,1),neigh(:,2));
    neigh = [neigh neigh_pos];
end