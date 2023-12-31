input = char(readlines('a15.txt'))'; % transpose so reading order in lin index
[r, c] = size(input');
diagVec1 = repmat([ones(c-1, 1); 0], r, 1);
diagVec1 = diagVec1(1:end-1);
diagVec2 = ones(c*(r-1), 1);
adj = diag(diagVec1, 1) + diag(diagVec2, c);
adj = adj+adj'; % base graph, build adjacency matrix
baseG = graph(adj,strsplit(num2str(1:numel(input)),' '));
% part 2: increase elfe attack power until no elve dies
num_elves = sum(input == 'E','all');
atk = 3;
start_elves = find(ismember(input(:),"E"));
start_goblins = find(ismember(input(:),"G"));
start_units = sort([start_elves;start_goblins]);
new_round = input;
while any(new_round == 'G','all') || sum(new_round == 'E','all') < num_elves
    new_round = input;
    atk = atk + 1;
    unit_map = dictionary(start_units,start_units); % map from start to curr
    hit_points = dictionary(start_units,200*ones(height(start_units),1));
    attack_power = dictionary(start_elves,atk*ones(height(start_elves),1));
    attack_power(start_goblins) = 3*ones(height(start_goblins),1);
    t = 0;
    while any(new_round == 'E','all') && any(new_round == 'G','all')
        units = find(ismember(new_round(:),["E","G"]));    
        t = t + 1;
        remaining_units = units;
        while ~isempty(remaining_units)        
            unit = remaining_units(1); remaining_units(1) = [];
            % move
            [target, nextStep] = chooseTarget(new_round, unit, baseG); 
            if target == -1
                continue % no more free spots or not reachable. Also not in attacking range
            end
            if target ~= 0
                % not in range
                new_round(nextStep) = new_round(unit);
                new_round(unit) = '.';
                keys_ = keys(unit_map);
                unit_map(keys_(unit_map.values == unit)) = nextStep;
                unit = nextStep;
            end        
            % attacking
            [hit_points, new_round, unit_map] = attack(new_round, unit, hit_points, attack_power, unit_map);
            if ~(any(new_round == 'E','all') && any(new_round == 'G','all'))
                break
            end
            % did we remove one?
            if length(unit_map.values) ~= length(units)
                remaining_units(~ismember(remaining_units,unit_map.values)) = [];
            end
        end    
    end
end
hps = hit_points.values;
if isempty(remaining_units)
    out = sum(hps(hps>0)) * (t)
else
    out = sum(hps(hps>0)) * (t-1)
end

function [hit_points, map, unit_map] = attack(map, unit, hit_points, attack_power, unit_map)
    elve = find(map == 'E');
    goblin = find(map == 'G');
    
    if ismember(unit, elve)
        friend = elve;
        enemy = goblin;
    else
        friend = goblin;
        enemy = elve;       
    end    
    keys_ = unit_map.keys;     
    move_mat = [1 -1 height(map) -height(map)];
    adj_to_enemy = enemy + move_mat;
    if ismember(unit,adj_to_enemy)
        % can attack
        enemy_in_range = enemy(any(ismember(adj_to_enemy, unit),2));
        % select target with the fewest hit points
        if numel(enemy_in_range) > 1
            temp_mat = unit_map.values == enemy_in_range';
            temp_I = mod(find(temp_mat')-1,numel(enemy_in_range))+1;
            [~,I] = sort(temp_I);
            hps = hit_points(keys_(ismember(unit_map.values,enemy_in_range)));
            hps = hps(I);
            min_hp = min(hps);
            target = min(enemy_in_range(hps == min_hp));
        else
            target = enemy_in_range;
        end
    else
        return
    end
    % deal damage
    og_e = keys_(unit_map.values == target);
    og_f = keys_(unit_map.values == unit);   
    atk = attack_power(og_f);
    hit_points(og_e) = hit_points(og_e) - atk;
    if hit_points(og_e) <= 0
        map(target) = '.';
        unit_map(og_e) = [];
    end
end

function [chosen, nextStep] = chooseTarget(map, unit, baseG)    
    elve = find(map == 'E');
    goblin = find(map == 'G');    
    if ismember(unit, elve)
        friend = elve;
        enemy = goblin;
    elseif ismember(unit, goblin)
        friend = goblin;
        enemy = elve;
    else
        error('Unit is neither elve nor goblin. Not possible!')
    end
    move_mat = [1 -1 height(map) -height(map)];
    adj_to_enemy = enemy + move_mat;
    if ismember(unit,adj_to_enemy)
        chosen = 0; % already in attacking range
        nextStep = 0;
        return
    end
    free = find(map == '.');
    free_next_to_enemy = unique(adj_to_enemy(ismember(adj_to_enemy(:),free)));
    if isempty(free_next_to_enemy)
        chosen = -1;
        nextStep = 0;
        return
    end
    blocked = find(map == '#');
    % build a graph of possible moves. Blocked is every unit, so friends
    % and enemies
    G = buildGraph(baseG, [blocked;friend(friend ~= unit)], enemy);
    Gnodes = string(G.Nodes.Variables);
    bins = conncomp(G);   
    unit_bin = bins(Gnodes == string(unit));
    reachable_next_to_enemy = free_next_to_enemy(ismember(string(free_next_to_enemy),Gnodes(bins == unit_bin)));
    if isempty(reachable_next_to_enemy)
        chosen = -1;
        nextStep = 0;
        return
    end
    dists = distances(G,string(unit),string(reachable_next_to_enemy));
    [shortestPathLength,I] = min(dists);
    chosen = min(reachable_next_to_enemy(dists == shortestPathLength));    
    nextStepOptions = unit + move_mat;
    nextStepOptions = nextStepOptions(ismember(nextStepOptions, free));
    dist_after_opt = distances(G,string(nextStepOptions), string(chosen));
    minD = min(dist_after_opt);
    nextStep = min(nextStepOptions(dist_after_opt == minD));
end

function G = buildGraph(baseG, blocked, enemy)
    G = baseG.rmnode(string(blocked));
    G = G.rmnode(string(enemy));
end