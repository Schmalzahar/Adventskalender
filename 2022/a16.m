%% Day 16
lines = readlines("a16.txt");
% 30 minute limit
% opening a valves takes 1 minute
% walking to the next cave also takes 1 minute
% first create a tree of the cave structure\
G = graph;
flow_rates = {};%zeros(length(lines),1);
num_valves = 0;
for i=1:height(lines)
    line = lines(i);
    line_info = regexp(line,"Valve (\w{2}) has flow rate=(\d+); tunnel[s]* lead[s]* to valve[s]* (\w+(, \w+)*)","tokens");
    G = G.addedge(line_info{1}{1},split(line_info{1}{3},", "));
    if str2double(line_info{1}{2}) > 0
        num_valves = num_valves + 1;
        flow_rates.(line_info{1}{1}) = str2double(line_info{1}{2});
    end
    
end


pressure = 0;
pressure_rate = 0;
tic
[pressure,max_path] = BFS(G, flow_rates, "AA", 0, pressure, pressure_rate, [], {}, 0, [], [], num_valves)
toc
function [max_pressure, max_path] = BFS(G, flow_rates, root, t, pressure, pressure_rate, valves_opened, rooms_visited, max_pressure, max_path, path, num_valves)
    options = G.neighbors(root);
    rooms_visited.(root) = pressure_rate;
    valve_rooms = fields(flow_rates);
    if ismember(root,valve_rooms)
        options = ["valve"; options];
    end
    root;
    options;
    if isempty(path)
        path = root;
    end
%     if ~isempty(max_path)
%         max_valve_order = max_path(find(max_path == "valve")-1);
%     end
    for i1 = 1:length(options)
        o1 = options(i1);
        if ismember(o1,fields(rooms_visited))% && length(valves_opened) < num_valves
            if pressure_rate == rooms_visited.(o1)
                continue
            end
        end
        if o1 == "valve" && ~isempty(valves_opened) && ismember(root, valves_opened)
            continue
        end
        if (length(valves_opened) == num_valves) && max_pressure ~= 0
            % see if maximum can be reached
            if ((30-t)*pressure_rate + pressure) <= max_pressure
                return
            end
        elseif (length(valves_opened) + 1== num_valves) && max_pressure ~= 0
            % can the maximum be reached when opening the last valve NOW
            last_rate = flow_rates.(valve_rooms{~ismember(valve_rooms, valves_opened)});
            if ((30-t)*pressure_rate + pressure + (29-t)*last_rate) <= max_pressure
                return
            else
                last_valve = valve_rooms{~ismember(valve_rooms, valves_opened)};
                [~,dist_to_last_valve] = G.shortestpath(root,last_valve);
                if (pressure + (30-t)*pressure_rate + (29 -t - dist_to_last_valve)*last_rate) <= max_pressure
                    return
                end
            end
        end
    
        
        path(end+1) = o1;
        pressure = pressure + pressure_rate;
        t = t + 1;
        if t==6
            pressure;
            path;
            if pressure > max_pressure
                max_pressure = pressure;
                max_path = path;
            end
            t = t - 1;
            pressure = pressure - pressure_rate;
            path = path(1:end-1);
            continue
        end
        if o1 == "valve" && (isempty(valves_opened) || ~ismember(root, valves_opened))
            pressure_rate = pressure_rate + flow_rates.(root);
            if isempty(valves_opened)
                valves_opened = root;
            else
                valves_opened(end+1) = root;
            end
            [max_pressure, max_path] = BFS(G, flow_rates, root, t, pressure, pressure_rate, valves_opened, rooms_visited, max_pressure, max_path, path, num_valves);
            t = t - 1;
            pressure_rate = pressure_rate - flow_rates.(root);
            pressure = pressure - pressure_rate;
            path = path(1:end-1);
            valves_opened = valves_opened(1:end-1);
        elseif o1 ~= "valve"
            [max_pressure, max_path] = BFS(G, flow_rates, o1, t, pressure, pressure_rate, valves_opened, rooms_visited, max_pressure, max_path, path, num_valves);
            t = t - 1;
            pressure = pressure - pressure_rate;
            path = path(1:end-1);
        end
        
        
    end
    % Ran out of options, wrong path
end