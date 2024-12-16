input = char(readlines("a16.txt"));
start_pos = find(input == 'S');
fin = find(input == 'E');

pq = PriorityQueue();

% start facing east
pq.push([start_pos 1 0], 0); %1: right, 2:up, 3:left, 4:down
dirs = [size(input,1) -1 -size(input,1) 1];

seen = zeros(numel(input),4,2);

while ~isempty(pq.items)
    [posdir, prio] = pq.pop;
    pos = posdir(1); dir = posdir(2);
    if seen(pos, dir,1) == 0
        seen(pos, dir,1) = prio;
    elseif seen(pos, dir,1) < prio
        continue
    else
        seen(pos, dir,1) = prio;
    end
    possible_dirs = input(pos + dirs) ~= '#';
    for p=1:4
        if possible_dirs(p) == 1
            new_pos = pos + dirs(p);
            if p ~= dir
                cost = 1000;
            else
                cost = 0;
            end
            seen(new_pos, p, 2) = pos;
            pq.push([new_pos p pos], prio + 1 + cost);
        end
    end
end

score = min(seen(fin,seen(fin,:)>0))

%% part 2
paths = [];

% walk until score is up


temp_path = [fin 4 score];

allPaths = walk(input, temp_path, dirs, []);
   
part2 = length(unique(allPaths)) + 1 % start as well    


function allPaths = walk(input, temp_path, dirs, allPaths)
    possible_dirs = input(temp_path(end,1) + dirs) ~= '#';
    for p=1:4
        if possible_dirs(p) == 1
            dir = temp_path(end,2);
            if p == dir || mod(dir-2,2) ~= mod(p,2)
                new_pos = temp_path(end,1) + dirs(p);
                if ismember(new_pos,temp_path(:,1))
                    return
                end
                if p ~= dir
                    cost = 1000;
                else
                    cost = 0;
                end
                new_cost = temp_path(end,3)-1-cost;
                if new_cost < 0
                    return
                % elseif new_cost == 0 && input(new_pos) == 'S'
                %     test = 1;
                % end
                elseif input(new_pos) == 'S'
                    if (p == 1 && new_cost == 0) || p ~= 1 && new_cost == 1000
                        % done
                        allPaths = [allPaths; temp_path(:,1)];
                        return
                    end
                    return
                end
                
                temp_path = [temp_path; new_pos p new_cost];
                temp_input = input;
                % temp_input(temp_path(:,1)) = 'O'
                allPaths = walk(input, temp_path, dirs, allPaths);
                temp_path = temp_path(1:end-1,:);
            end
        end
    end   
end