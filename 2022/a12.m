%% Day 12
% part 1: 9:18-10:53
% part 2: 10:53-11:01
 
height_map = char(readlines("a12.txt"))-'a';
start_num = -14; end_num = -28;
[sx,sy] = find(height_map == start_num, 2);
[ex, ey] = find(height_map == end_num, 2);
height_map(sx,sy) = 0; height_map(ex,ey)= 25;
part = 1;

% Dijkstra
% possible is: at most one up and as much down as you want, only left,
% right up and down, no diagonal

% We start at the finish node and search the start
source_node = sub2ind(size(height_map), ex, ey);

num_nodes = numel(height_map);
dist = inf(1, num_nodes);
prev = zeros(1, num_nodes);

% Set the distance to the source node to 0
dist(source_node) = 0;

% Create a priority queue to store the nodes
queue = PriorityQueue();
queue.push(source_node, 0);

% Repeat until the queue is empty
while ~queue.isEmpty()
    % Pop the node with the smallest distance
    curr_node = queue.pop();
    
    neighbors = getNeighbors(curr_node, height_map);
    % Iterate over the neighbors of the current node
    for i = 1:length(neighbors)
        neighbor = neighbors(i);
        % Calculate the distance to the neighbor
        alt = dist(curr_node) + 1;
        % Update the distance and previous arrays if the calculated
        % distance is less than the current distance
        if alt < dist(neighbor)
            dist(neighbor) = alt;
            prev(neighbor) = curr_node;
            queue.push(neighbor, alt);
        end
    end
end

% Result output
if part == 1
    dist(sub2ind(size(height_map), sx, sy))
elseif part == 2
    min(dist(height_map == 0))
end

function neighbors = getNeighbors(curr_node, height_map)
    % possible is: at most one up and as much down as you want, only left,
    % right up and down, no diagonal
    value = height_map(curr_node);
    dummy_mat = zeros(size(height_map));
    dummy_mat(curr_node) = 1;
    surrounding_indices = find(conv2(dummy_mat,[0,1,0;1,0,1;0,1,0],'same'));
    surrounding_values = height_map(surrounding_indices);
    neighbors = surrounding_indices(value<=surrounding_values+1);
end