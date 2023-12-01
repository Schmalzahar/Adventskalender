%% Day 16
lines = readlines("a16.txt");
% 30 minute limit
% opening a valves takes 1 minute
% walking to the next cave also takes 1 minute
% first create a tree of the cave structure\
G = graph;
flow_rates = {};%zeros(length(lines),1);
for i=1:height(lines)
    line = lines(i);
    line_info = regexp(line,"Valve (\w{2}) has flow rate=(\d+); tunnel[s]* lead[s]* to valve[s]* (\w+(, \w+)*)","tokens");
    G = G.addedge(line_info{1}{1},split(line_info{1}{3},", "));
    if str2double(line_info{1}{2}) > 0
        flow_rates.(line_info{1}{1}) = str2double(line_info{1}{2});
    end    
end
valve_rooms = fields(flow_rates);
root = "AA";
t = 0;
tmax = 30;
pressure = 0;

%% part 1
dists = {};
tic
[max_pressure, max_path, ~] = DFS(G, flow_rates, root, t, tmax, pressure, [], 0, [], valve_rooms, dists, zeros(size(valve_rooms)));
toc
max_pressure
max_path
%% part 2
dists = {};
tic
[max_pressure, max_path, ~] = DFS2(G, flow_rates, root, root, t, t, 26, pressure, [], [], 0, max_path, valve_rooms, dists, zeros(size(valve_rooms)), 1);
toc
max_pressure
max_path
%%
function [max_pressure, max_path, dists] = DFS(G, flow_rates, root, t, tmax, pressure, valves, max_pressure, max_path, valve_rooms, dists, openValves)
    [dist, dists] = getDist(G, root,valve_rooms, dists, flow_rates);     
    for v = dist.I'
        if openValves(v) == 1 || dist.dist(v)+1+t>=tmax
            continue
        end
        tdiff = dist.dist(v) + 1;
        valve = valve_rooms{v};
        pdiff = (tmax - t - tdiff) * flow_rates.(valve);
        openValves(v) = 1;
        [max_pressure, max_path, dists] = DFS(G, flow_rates, valve, t+tdiff, tmax, pressure+pdiff, [valves; valve], max_pressure, max_path, valve_rooms, dists, openValves);
        openValves(v) = 0;
    end
    if pressure > max_pressure
        max_pressure = pressure;
        max_path = string(valves);
    end
end
%% Part 2
function [max_pressure, max_path, dists] = DFS2(G, flow_rates, root1, root2, t1, t2, tmax, pressure, valves1, valves2, max_pressure, max_path, valve_rooms, dists, openValves, human)
    [dist1, dists] = getDist(G, root1, valve_rooms, dists, flow_rates);     
        [dist2, dists] = getDist(G, root2, valve_rooms, dists, flow_rates); 
    
    if human == 1
        for v = dist1.I' % human
            valve1 = valve_rooms{v};
            if openValves(v) == 1
                continue
            end
            if dist1.dist(v)+1+t1>=tmax  
                % run elephant
                for w = dist2.I'
                    valve2 = valve_rooms{w};
                    if openValves(w) == 1 || dist2.dist(w)+1+t2>=tmax
                        continue
                    end
                    t2diff = dist2.dist(w) + 1;
                    p2diff = (tmax - t2 - t2diff) * flow_rates.(valve2);
                    openValves(w) = 1;
                    [max_pressure, max_path, dists] = DFS2(G, flow_rates, root1, valve2, t1, t2+t2diff, tmax, pressure+p2diff, valves1, [valves2; valve2], max_pressure, max_path, valve_rooms, dists, openValves, 0);
                    openValves(w) = 0;
                end
            else
                t1diff = dist1.dist(v) + 1;
                p1diff = (tmax - t1 - t1diff) * flow_rates.(valve1);
                openValves(v) = 1;
                [max_pressure, max_path, dists] = DFS2(G, flow_rates, valve1, root2, t1+t1diff, t2, tmax, pressure+p1diff, [valves1; valve1], valves2, max_pressure, max_path, valve_rooms, dists, openValves, 1);
                openValves(v) = 0;
                % run elephant
                [max_pressure, max_path, dists] = DFS2(G, flow_rates, valve1, root2, t1, t2, tmax, pressure, valves1 , valves2, max_pressure, max_path, valve_rooms, dists, openValves, 0);
            end            
        end
    elseif human == 0 % elephant
        for w = dist2.I'
            valve2 = valve_rooms{w};
            if openValves(w) == 1 || dist2.dist(w)+1+t2>=tmax
                continue
            end
            t2diff = dist2.dist(w) + 1;
            p2diff = (tmax - t2 - t2diff) * flow_rates.(valve2);
            openValves(w) = 1;
            [max_pressure, max_path, dists] = DFS2(G, flow_rates, root1, valve2, t1, t2+t2diff, tmax, pressure+p2diff, valves1, [valves2; valve2], max_pressure, max_path, valve_rooms, dists, openValves, 0);                
            openValves(w) = 0;
        end
    end
    if pressure > max_pressure
        max_pressure = pressure;
        if length(string(valves1)) ~= length(string(valves2))
            if length(valves1) < length(valves2)
                max_path = [[string(valves1); repmat("",length(string(valves2))-length(string(valves1)),1)], string(valves2)];
            else
                max_path = [string(valves1), [string(valves2);repmat("",length(string(valves1))-length(string(valves2)),1)]];
            end
        else
            max_path = [string(valves1) ,string(valves2)];
        end        
    end
end

function [dist, dists] = getDist(G, root,valve_rooms, dists, flow_rates)
    if ~isfield(dists,root)
        temp = zeros(size(valve_rooms));
        for i=1:height(valve_rooms)
            [~,temp(i)] = G.shortestpath(root, valve_rooms{i});
        end
        flow_nums = struct2array(flow_rates)';
        temp_mat = [temp,flow_nums];
        [~, I] = sortrows(temp_mat,[1,2],{'ascend','descend'});
        dists.(root).I = I;
        dists.(root).dist = temp;
    end
    dist = dists.(root);
end