%% Day 23
part = 2;
if part == 1
    room = zeros(19,1);
    % room(12) = 2; room(13) = 1; room(14)=3;room(15)=4;room(16)=2;room(17)=3;room(18)=4;room(19)=1;
    room(12) = 2; room(13:4) = 2; room(14)=3;room(15)=3;room(16)=1;room(17)=4;room(18)=4;room(19)=1;
    groom = graph([1 2 8 8 3 9 9 4 10 10 5 11 11 6 12 14 16 18],[2 8 12 3 9 14 4 10 16 5 11 18 6 7 13 15 17 19],[],{'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19'});
else
    room = zeros(27,1);
%     room(12) = 2; room(13:14) = 4; room(15)=1;room(16)=3;room(17)=3;room(18)=2;room(19)=4;room(20:21)=2;room(22)=1;room(23)=3;room(24)=4;room(25)=1;room(26)=3;room(27)=1;
    room(12) = 2; room(13:14) = 4; room(15)=2;room(16)=3;room(17)=3;room(18)=2;room(19)=3;room(20) = 1;room(21)=2;room(22)=1;room(23)=4;room(24)=4;room(25)=1;room(26)=3;room(27)=1;
    groom = graph([1 2 8 8 3 9 9 4 10 10 5 11 11 6 12 13 14 16 17 18 20 21 22 24 25 26],[2 8 12 3 9 16 4 10 20 5 11 24 6 7 13 14 15 17 18 19 21 22 23 25 26 27],[], ...
        string(1:27));
%     plot(groom)
end
% room = move(room, 24, 7);
% room = move(room, 25, 1);
% room = move(room, 20, 6);
% room = move(room, 21, 5);
% tic
% test = minCostToFinish(room, groom)
% toc
% tic
% cachedAVmodes = containers.Map;
% [energy, path,~,~,~] = bf(room, groom, 0, [], [], {}, cachedAVmodes)
% toc
% a = getMinCostMove(room,groom)
% getMovable(room, groom)
% room = move(room, 24, 7);
% getMovable(room, groom)
% room = move(room, 25, 1);
% room = move(room, 15, 4);
% room = move(room, 3, 15);
% room = move(room, 12, 14);
% room = move(room, 18, 5);
% room = move(room, 19, 6);
% room = move(room, 5, 19);
% room = move(room, 4, 19);
% room = move(room, 6, 12);
% [ops, costs] = availOps(room, groom, 20)
profile on -history
[energy, path] = A_Star(room, groom)

function [energy, path] = A_Star(room, groom)
    room_name = append("r",join(string(room)',''));
%     openSet = getMinCostMove(room,groom);
    openSet.(room_name) = room;
%     cameFrom = containers.Map;
    cameFrom = struct;
%     gScore = containers.Map;
    gScore = struct;
%     gScore(join(string(room)','')) = 0;
    gScore.(room_name) = 0;
%     fScore = containers.Map;
%     fScore(join(string(room)','')) = minCostToFinish(room, groom);
    fScore = struct;
    fScore.(room_name) = minCostToFinish(room, groom);
%     fScore = minCostToFinish(room, groom);
    while ~isempty(openSet)
        current = minfScoreRoom(openSet, fScore);
        current_name = append("r",join(string(current)',''));
        if isWon(current)
            energy = "todo";
            path = reconstruct_path(cameFrom, current);
            return
        end
        openSet = rmfield(openSet, current_name);
        set = getMinCostMove(current, groom);
        for i=1:numel(set.costs)
            if set.ops(i) == 0
                continue
            end
            [i1,i2] = ind2sub(size(set.costs),i);
            neighbor = move(current, set.starts(i2), set.ops(i));
            neighbor_name = append("r",join(string(neighbor)',''));
            tentative_gScore = gScore.(current_name) + set.costs(i);
            if ~isfield(gScore,append("r",join(string(neighbor)','')))
                gScore.(neighbor_name) = inf;
            end
            if tentative_gScore < gScore.(neighbor_name)
                cameFrom.(neighbor_name) = current;
                gScore.(neighbor_name) = tentative_gScore;
                fScore.(neighbor_name) = tentative_gScore + minCostToFinish(neighbor, groom);
                if ~isfield(openSet, neighbor_name)
                    openSet.(neighbor_name) = neighbor;
                end
            end
        end
    end
end

function out_room = minfScoreRoom(openSet, fScore)
    setNames = fieldnames(openSet);
    while true
        C = struct2cell(fScore);
        fNames = fieldnames(fScore);
        [~,ind] = min([C{:}]);
        if ismember(fNames{ind}, setNames)
            break
        else
            fScore = rmfield(fScore,fNames{ind});
        end
    end
    out_room = openSet.(fNames{ind});
end

function total_path = reconstruct_path(cameFrom, current)
    total_path = current;
    while true
        if cachedAVmodes.isKey(join(string(room)',''))
            current = cameFrom.values(current);
            total_path = [current, total_path];
        else
            break
        end
    end
end

function set = getMinCostMove(room, groom, amount)
    ops = zeros(7,27);
    costs = zeros(size(ops));
    starts = zeros(1,27);
    for i=1:27 % 19
        [ops_i,costs_i] = availOps(room, groom, i);
        if isempty(ops_i)
            continue
        end
        [costs_i,b] = sort(costs_i);
        ops(1:height(ops_i),i) = ops_i(b);
        costs(1:height(ops_i),i) = costs_i;
        starts(1,i) = i;
    end
    % remove zeros
    costs = costs(:,~all(costs == 0));
    ops = ops(:,~all(ops == 0));
    starts = starts(starts~=0);
    if nargin == 3
        % get the min cost
        [min_cost,min_cost_lin] = min(costs,[],'all');
        min_end_pos = ops(min_cost_lin);
        [~,spos] = ind2sub(size(costs),min_cost_lin);
        min_start_pos = starts(spos);
        set.min_start_pos = min_start_pos;
        set.min_end_pos = min_end_pos;
        set.min_cost = min_cost;
        set.fScore = minCostToFinish(room, groom);
    else
        set.costs = costs;
        set.ops = ops;
        set.starts = starts;
    end
end

function [all_energies,all_paths, energy, path, cachedAVmodes] = bf(room, groom, prevcosts, prevnodes, all_energies, all_paths, cachedAVmodes)
%     if cachedAVmodes.isKey(join(string(room)',''))
%         avmove = cell2mat(cachedAVmodes.values({join(string(room)','')}));
%     else    
%     avmove = getMovable(room, groom);
%         cachedAVmodes(join(string(room)','')) = avmove';
%     end
    if cachedAVmodes.isKey(join(string(room)',''))
        out = cachedAVmodes.values({join(string(room)','')});
        out = out{:};
        costs = out{1};
        ops = out{2};
        starts = out{3};
        p = randperm(width(ops));
        costs = costs(:,p);
        ops = ops(:,p);
        starts = starts(:,p);
    else
        ops = zeros(7,27);
        costs = zeros(size(ops));
        starts = zeros(1,27);
        for i=1:27 % 19
            [ops_i,costs_i] = availOps(room, groom, i);
            if isempty(ops_i)
                continue
            end
            [costs_i,b] = sort(costs_i);
            ops(1:height(ops_i),i) = ops_i(b);
            costs(1:height(ops_i),i) = costs_i;
            starts(1,i) = i;
        end
        % remove zeros
        costs = costs(:,~all(costs == 0));
        ops = ops(:,~all(ops == 0));
        starts = starts(starts~=0);
        % do those with minimal cost first
    %     [~,b] = sort(sum(costs));
    %     costs = costs(:,b);
    %     ops = ops(:,b);
    %     starts = starts(b);
%         costs = fliplr(costs);
%         ops = fliplr(ops);
%         starts = fliplr(starts);
%         p = randperm(width(ops));
%         costs = costs(:,p);
%         ops = ops(:,p);
%         starts = starts(:,p);
        if isempty(starts)
            energy = 0;
            path = 0;
            return
        end
        results = {costs, ops, starts};
        cachedAVmodes(join(string(room)','')) = results;
    end
    for i1 = 1:width(costs) 
        % sort by cost
%         [costs_i,b] = sort(costs(:,i1));
%         ops_i = ops(b,i1);
        % remove zeros
        costs_i = costs(:,i1);
        ops_i = ops(:,i1);
        costs_i = costs_i(costs_i~=0);
        ops_i = ops_i(ops_i~=0);
        p = randperm(height(ops_i));
        costs_i = costs_i(p);
        ops_i = ops_i(p);
        %starts = starts(p);
        for i2 = 1:height(ops_i)
            if costs_i(i2) + prevcosts >= min(all_energies)
                energy = 0;
                path = 0;
                continue            
            end
            new_move = [starts(i1) ops_i(i2)];    
            new_prevnodes = cat(1,prevnodes, new_move);
            new_room = move(room, starts(i1), ops_i(i2));
            if ~isempty(all_energies) && (minCostToFinish(room, groom) + prevcosts >= min(all_energies))
                energy = 0;
                path = 0;
                return
            end
            if isWon(new_room)
                energy = prevcosts + costs_i(i2);
                path = new_prevnodes;
                if isempty(all_energies)
                    return
                end
                if energy >= min(all_energies)
                    energy = 0;
                    path = 0;
                    return
                else
                    return
                end
            end            
            [all_energies, all_paths, energy, path, cachedAVmodes] = bf(new_room, groom, costs_i(i2) + prevcosts, new_prevnodes, all_energies, all_paths, cachedAVmodes);
            % If it comes out here, it either is finished, or at the end of
            % a path and needs to backtrack
            if energy ~= 0
                energy
                all_energies = cat(1, all_energies, energy);
                all_paths{end+1} = path;
                energy = 0;
                path = [];
                continue
            end
        end
  
    end
end

function cost = minCostToFinish(room, groom)
    % Returns a lower bound for the cost to the finish position    
    pos = find(room > 0);
    cost = 0;
    part = 2;    
    for i=1:height(pos)
        posi = pos(i);
        typei = room(posi);
        % are we already there?
        if isCorrect(room,posi)
            continue
        end
        if part == 1
            switch typei
                case 1
                    goal = 12;
                case 2
                    goal = 14;
                case 3
                    goal = 16;
                case 4
                    goal = 18;
            end
        else
            switch typei
                case 1
                    goal = 12;
                case 2
                    goal = 16;
                case 3
                    goal = 20;
                case 4
                    goal = 24;
            end
        end
        [~,len] = shortestpath(groom, num2str(posi), num2str(goal));
        cost = cost + len * getMulti(typei);
    end
end

function [ops, costs] = availOps(room, groom, start)
    % What are the possible points the amphipod at start can move to? 
    ops = [];
    costs = [];
    part = 2;
    if room(start) == 0
        return
    end
    hallway = room(1:7) == 0; % empty spaces
    if part == 1
        room_down = [13 15 17 19];
        room_up = [12 14 16 18];
    else
        room_down = [13:15 17:19 21:23 25:27];
        room_up = [12 16 20 24];
    end
    rooms = cat(2,room_up,room_down);
    not_allowed = [8 9 10 11]; % rule 1
    occupied = find(room ~= 0);
    % can you even move?
    if any(start == room_down) && ~roomabove(rooms, room, start)
        % no
        return
    end
    rooms_reshaped = reshape(sort(rooms),[part*2,4]);
    [px,~] = find(rooms_reshaped == start);
    % Are all entrys in this room below it already correct? If so, do not move
    if isCorrect(room,start)
        % up or down? For up, check the lower ones  
        [above,below] = getAboveBelow(rooms, start);
        %lower_bool = isCorrect(room,start+1);
        lower_bool = true;
        for j=1:length(below)
            lower_bool = lower_bool && isCorrect(room,below(j));
        end
        if lower_bool
            % all lower entrys in this room are correct. Do not
            % move
            return
        else
            % at least one lower entry is false, thus the upper has to move to
            % make way for the lower entry
        end
    end
    
    if all(hallway == 1)
        % empty hallway, can use groom
        ops = (1:7)';
        costs = detcosts(groom,start,ops, room(start));
    else
        % someone is in the hallway. Where?
%         if start == 16 && room(21) == 0 && room(22) == 0 && room(4) == 0
%             test = 4;
%         end
        occupied_hallway = ~hallway;
        hallway_pos = find(occupied_hallway);
        groom_hallwayblock = rmnode(groom, hallway_pos(hallway_pos ~= start));
        possible_paths = str2double(string(nearest(groom_hallwayblock,num2str(start),Inf,'Method','unweighted')));
        ops = possible_paths(~ismember(possible_paths,not_allowed));
        ops = ops(~ismember(ops,occupied));
        if isempty(ops)
            return
        end
        if any(start == rooms)
            % case 1: move from room to hallway            
            if any(start == room_down)
                % remove the rooms above from ops
                [above,~] = getAboveBelow(rooms, start);
                ops(ismember(ops,above)) = [];
            end
            % remove room entries
            ops = ops(~ismember(ops,rooms));
%             if any(ismember(ops,rooms))
%                 % make sure that this is the correct room for this type
%                 ops = orrectOps(rooms,room(start),ops);
%                 if isempty(ops)
%                     return
%                 end
% 
%                 % do not go into the upper room if the lower rooms are
%                 % empty
%                 ops_room = ops(ismember(ops,rooms));
%                 if ~isempty(ops_room)
%                     ops = [ops_room(end);ops(~ismember(ops,rooms))];
%                     % do not go into the upper room if anything in the lower
%                     % rooms is wrong
%                     lower_bool = true;
%                     [~,below] = getAboveBelow(rooms, ops(ismember(ops,rooms)));
%                     for j=1:length(below)
%                         lower_bool = lower_bool && isCorrect(room,below(j));
%                     end
%                     if ~lower_bool
%                         % lower entry is false
%                         ops = ops(~ismember(ops,rooms));
%                     else
%                         % You can move into the correct place. Make that
%                         % move
%                         ops = ops(ismember(ops,rooms));
%                     end
%                 end 
%             end            
        else
            % case 2: move from hallway into the final correct room
            % the only allowed move from a hallway is into the correct room
            % and also only if the room is either empty or the other
            % entries are also correct
            ops = ops(~ismember(ops,1:7)); % remove hallway options
            ops = orrectOps(rooms,room(start), ops); % remove wrong rooms
            % Now, at most, 4 options are left. If the down room is free,
            % the up option is not allowed
            if isempty(ops)
                return
            end
            if any(ismember(ops,room_down))
                ops = ops(ismember(ops,room_down));                
            end
            ops = ops(end);
            % Check of everything below is correct
            lower_bool = true;
            [~,below] = getAboveBelow(rooms, ops);
            for j=1:length(below)
                lower_bool = lower_bool && isCorrect(room,below(j));
            end
            if ~lower_bool
                % lower entry is false
                ops = []; return
            end              
        end
        if ~isempty(ops)
            costs = detcosts(groom_hallwayblock, start, ops, room(start));
        else 
            costs = [];
        end
    end
end

function out = roomabove(rooms, room, start)
    % make sure every spot above is free
    % part 2
    part = 2;
    if part == 1
        len = 2;
    else
        len = 4;
    end
    room_split = reshape(sort(rooms),[len 4]);
    roomie = room(room_split);
    [posx,posy] = find(room_split == start);
    out = all(roomie(1:posx-1,posy) == 0);
end

function bool = isWon(room)
    bool = false;
    part = 2;
    if part == 1
        if room(12) == 1 && room(13) == 1 && room(14) == 2 && room(15) == 2 && room(16) == 3 && room(17) == 3 && room(18) == 4 && room(19) == 4
            bool = true;
        end
    else
        if all(room(12:15) == 1) && all(room(16:19) == 2) && all(room(20:23) == 3) && all(room(24:27) == 4)
            bool = true;
        end
    end
end

function bool = isCorrect(room, start)
    type = room(start);
    if ismember(start, getAllowed(type))
        bool = true;
    else
        bool = false;
    end
end

function correct_ops = orrectOps(rooms,type, ops)
    ops_rooms = ops(ismember(ops,rooms));
    ops_no_rooms = ops(~ismember(ops,rooms));
    ops_allowed_rooms = ops_rooms(ismember(ops_rooms,getAllowed(type)));
    correct_ops = cat(1,ops_no_rooms, ops_allowed_rooms);
end

function room_out = move(room_in, start, dest)
    % this does not check if the move is possible
    typ = room_in(start);
    room_out = room_in;
    room_out(start) = 0;
    room_out(dest) = typ;
end

function costs = detcosts(g, start, ops, type)
    start = string(start);
    ops = string(ops);
    costs = zeros(size(ops));
    for i=1:height(costs)
        len = length(shortestpath(g,start,ops(i))) - 1;
        costs(i) = len * getMulti(type);
    end
end

function multi = getMulti(type)
    switch type
        case 1
            multi = 1;
        case 2
            multi = 10;
        case 3
            multi = 100;
        case 4
            multi = 1000;
    end
end

function [above,below] = getAboveBelow(rooms, start)
    part = 2;
    rooms_reshaped = reshape(sort(rooms),[part*2,4]);
    [px,py] = find(rooms_reshaped == start);
    above = rooms_reshaped(1:px-1,py);
    below = rooms_reshaped(px+1:end,py);
end

function allowed_rooms = getAllowed(type)
    part = 2;
    if part == 1
        switch type
            case 1
                allowed_rooms = [12 13];
            case 2
                allowed_rooms = [14 15];
            case 3
                allowed_rooms = [16 17];
            case 4
                allowed_rooms = [18 19];
        end
    else
        switch type
            case 1
                allowed_rooms = [12 13 14 15];
            case 2
                allowed_rooms = [16 17 18 19];
            case 3
                allowed_rooms = [20 21 22 23];
            case 4
                allowed_rooms = [24 25 26 27];
        end
    end
end