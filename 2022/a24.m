%% Day 24

map = char(readlines("a24.txt"));
mapheight = size(map,1);
mapwidth = size(map,2);
start_pos = mapheight + 1;
end_pos = (mapwidth - 1) * mapheight;
right = find(map == '>');
down = find(map == 'v');
left = find(map == '<');
up = find(map == '^');
map = map - '.';
map(map ~= 0) = 1;

% generate all bliz steps and maps
bliz = cell(lcm(mapheight-2,mapwidth-2),4);
maps = ones(mapheight,mapwidth,size(bliz,1));
bliz(1,:) = {right, down, left, up};
maps(:,:,1) = map;
for i=2:size(bliz,1)
    new_right = bliz{i-1,1} + mapheight;
    new_right(new_right > (mapwidth-1) * mapheight) = new_right(new_right > (mapwidth-1) * mapheight) - (mapwidth-2) * mapheight;
    new_down = bliz{i-1,2} + 1;
    new_down(mod(new_down,mapheight) == 0) = new_down(mod(new_down,mapheight) == 0) - mapheight + 2;
    new_left = bliz{i-1,3} - mapheight;
    new_left(new_left < mapheight) = new_left(new_left < mapheight) + (mapwidth - 2) * mapheight;
    new_up = bliz{i-1,4} - 1;
    new_up(mod(new_up,mapheight) == 1) = new_up(mod(new_up,mapheight) == 1) + mapheight - 2;
    current_bliz = {new_right, new_down, new_left, new_up};
    bliz(i,:) = current_bliz;
    new_map = maps(:,:,i);
    new_map(start_pos) = 0;
    new_map(end_pos) = 0;
    new_map(2:end-1,2:end-1) = zeros(mapheight-2,mapwidth-2);
    new_map(unique(cat(1,current_bliz{:}))) = 1;
    maps(:,:,i) = new_map;
end

%% part 1
t = 0;
min_t = Inf;
max_t = (mapheight-1) + (mapwidth - 3)+1;
tic
while true
    visited = cell(max_t,1);
    visited{1,1} = start_pos;
    [visited,min_t] = maze(t, max_t, start_pos, end_pos, mapheight, mapwidth, maps, min_t,visited);
    if min_t == Inf
        max_t = 2 * max_t;
    else
        break
    end
end
min_t
toc

%% part 2
t = 0;
min_t = Inf;
max_t = 4*((mapheight-1) + (mapwidth - 3)+1)+800;
tic
while true
    visited = cell(max_t,1);
    visited{1,1} = start_pos;
    [visited,min_t] = maze(t, max_t, start_pos, end_pos, mapheight, mapwidth, maps, min_t,visited);
    if min_t == Inf
        max_t = 2 * max_t;
    else
        % back to start
        visited(min_t+2:end) = cell(max_t-min_t-1,1);
        visited{min_t+1,1} = end_pos;
        [visited,min_t] = maze(min_t, max_t, end_pos, start_pos, mapheight, mapwidth, maps, Inf,visited);
        if min_t == Inf
            max_t = 2 * max_t;
        else
            % back to end
            visited(min_t+2:end) = cell(max_t-min_t-1,1);
            visited{min_t+1,1} = start_pos;
            [visited,min_t] = maze(min_t, max_t, start_pos, end_pos, mapheight, mapwidth, maps, Inf,visited);
            if min_t == Inf
                max_t = 2 * max_t;
            else
                break
            end
        end
    end
end
toc
min_t
%%
function [visited,min_t] = maze(t, max_t, pos, end_pos, mapheight, mapwidth, map, min_t,visited)
    t = t + 1;
    if t == max_t || t > min_t
        return
    end

    current_map = map(:,:,mod(t,size(map,3))+1);
    % options
    if pos == mapheight+1
        surrounding_indices = [pos, pos+1]';
    elseif pos == (mapwidth-1)*mapheight
        surrounding_indices = [pos, pos-1]';
    else
        surrounding_indices = [pos, pos-1, pos+1,pos-mapheight,pos+mapheight]';
    end
    options = surrounding_indices(current_map(surrounding_indices) == 0);
    if isempty(options)
        return
    end
    % sort options by Manhattan distance to end_pos
    [options_row, options_col] = ind2sub(size(current_map), options);
    [end_row, end_col] = ind2sub(size(current_map), end_pos);
    distances = abs(options_row - end_row) + abs(options_col - end_col);
    [distances,I] = sort(distances);
    options = options(I);

    % Go through each option
    for i = 1:length(options)
        o = options(i);        
        if min_t ~= Inf
            if min_t - t < distances(i)
                continue
            end
        elseif max_t - t < distances(i)
            continue
        end
        if o == end_pos
            if t < min_t
                min_t = t;
            end
            return
        end
        if isempty(visited{t+1,1})
            visited{t+1,1} = o;
        elseif ~ismember(o,visited{t+1,1})
            visited{t+1,1} = [visited{t+1,1} o];
        else % been there, done that
            continue
        end
        [visited,min_t] = maze(t, max_t, o, end_pos, mapheight, mapwidth, map, min_t,visited);
    end
end