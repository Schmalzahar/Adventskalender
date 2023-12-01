%% Day 19
tic 
blueprints = readlines("a19.txt");
quality_level = 0;
max_three = 0;
three_temp = 1;
for i = 1:length(blueprints)
    blueprint = char(blueprints(i));
    info = extract(blueprint,digitsPattern);
    minerals = [0,0,0,0]; % ore, clay, obsidian, geode                                                                                                                                                                                  
    robots = [1,0,0,0];
    costs = zeros(3,4);
    costs(1,1) = str2double(info{2});
    costs(1,2) = str2double(info{3});
    costs(1,3) = str2double(info{4});
    costs(2,3) = str2double(info{5});
    costs(1,4) = str2double(info{6});
    costs(3,4) = str2double(info{7});
    [max_geodes, max_path] = maxGeodeSearch(minerals, costs, robots, 0, 32, 0, [], []);
    quality_level = quality_level + i * max_geodes;
    three_temp = three_temp * max_geodes;
    if i == 0
        if three_temp > max_three 
            max_three = three_temp;
        end
        three_temp = 1;
    end
    i
end
quality_level   
max_three
toc
function [max_geodes, max_path] = maxGeodeSearch(minerals, costs, robots, t, tmax, max_geodes, max_path, path)
    t = t+1;   
    new_options = flip(find(all(costs <= minerals(1:3)')));
    max_costs = [max(costs,[],2)' inf];
    if any(new_options == 4) % if its possible to build geode, always build
        new_options = 4;
    elseif ~isempty(new_options)
        wait = false;
        % see if these is an argument for not producing a robot this turn
        % can be made        
        % Is it possible to build other robots if we wait a little longer?
        for j=1:4
            rj = costs(:,j) - minerals(1:3)';
            rj(rj<=0) = 0;
            if ~any(isinf(rj ./ robots(1:3)')) && robots(j) < max_costs(j)
                time_needed = max(rj ./ robots(1:3)');
                if time_needed < (tmax - t)
                    wait = true;
                    break
                end
            end
        end
        if wait
            new_options = [ new_options 0];
        end
    else
        new_options = 0;
    end

    for o = new_options
        if o ~= 0 && ~isempty(path) && length(path) > 1 && path(end) == 0 
            last_round = minerals - robots;
            cost_needed = [costs(:,o)' 0];
            if all(last_round >= cost_needed)
                % would have been able to build in the previous round, dont
                % build now
                continue
            end
        end
        if o > 0 && robots(o) >= max_costs(o)
            continue
        end
        if t == tmax
            if minerals(4) + robots(4) > max_geodes
                max_geodes = minerals(4) + robots(4);
                max_path = path;
            end
            return
        end
        if max_geodes > 0
            % time left
            t_left = tmax - t + 1;
            geo = minerals(4);
            % if we build a geode robot every turn, can we exceed the
            % maximum? If not, terminate
            poss_max = geo + t_left * robots(4) + sum(1:(t_left - 1));
            if poss_max <= max_geodes
                return
            end
        end
        new_robots = zeros(1,4);
        if o > 0
            new_robots(o) = 1;
            [max_geodes, max_path] = maxGeodeSearch(minerals + robots - [costs(:,o)' 0], costs, robots + new_robots, t, tmax, max_geodes, max_path, [path o]);
        else
            [max_geodes, max_path] = maxGeodeSearch(minerals + robots, costs, robots, t, tmax, max_geodes, max_path, [path 0]);
        end
    end      
end