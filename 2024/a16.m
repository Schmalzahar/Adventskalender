input = char(readlines("a16.txt"));
start_pos = find(input == 'S');
fin = find(input == 'E');
tic
[score, path] = minScoreFromStartToFin(input, fin, start_pos, 4, 3, 0); % start with east dir, final dir not specified
score
toc
tic

%% part 2
%dirs: 1: right, 2:up, 3:left, 4:down
allPaths = findAllPathsFromStartToFin(input, fin, start_pos, 4, 1, score, flip(path));

numel(allPaths)

toc
function [minScore, minPath] = minScoreFromStartToFin(input, start_pos, fin_pos, start_dir, endDir, maxScore)    
    pq = PriorityQueue();    
    pq.push([start_pos start_dir 0], 0); 
    dirs = [size(input,1) -1 -size(input,1) 1]; %dirs: 1: right, 2:up, 3:left, 4:down
    
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
            if possible_dirs(p) && (p == dir || mod(dir-2,2) ~= mod(p,2)) % dont turn back
                new_pos = pos + dirs(p);
                if p ~= dir
                    cost = 1000;
                else
                    cost = 0;
                end
                seen(new_pos, p, 2) = pos;
                new_cost = prio + 1 + cost;
                if maxScore ~= 0 && new_cost > maxScore
                    continue
                end
                pq.push([new_pos p pos], new_cost);
            end
        end
    end
    if endDir == 0
        minScore = min(seen(fin_pos,seen(fin_pos,:,1)>0,1));
    elseif seen(fin_pos,endDir,1) == 0
        % we have to turn
        minScore = min(seen(fin_pos,seen(fin_pos,:,1)>0,1)) + 1000;        
    else
        minScore = seen(fin_pos, endDir, 1);
    end
    %% retrace path
    minPath = fin_pos;
    if all(seen(minPath(end),:,1) == 0)
        % not possible to reach
        minScore = Inf;
        minPath = [];
        return
    end
    if endDir == 0 || seen(minPath(end),endDir,2) == 0
        idx = seen(minPath(end),:,1) == min(seen(minPath(end),seen(minPath(end),:,1)>0,1));
    else
        idx = endDir;
    end
    while true
        if numel(seen(minPath(end),idx,2)) > 1
            s = seen(minPath(end),idx,2);
            minPath(end+1) = s(1);
        else
            minPath(end+1) = seen(minPath(end),idx,2);
        end
        
        if minPath(end) == start_pos
            break
        end
        % next idx
        idx = seen(minPath(end),:,1) == min(seen(minPath(end),seen(minPath(end),:,1)>0,1));
    end
end


function allPaths = findAllPathsFromStartToFin(input, start_pos, fin_pos, start_dir, end_dir, score, path)
% start at the fin and go to the first crossroad. Then search the other
% direction
    dirs = [size(input,1) -1 -size(input,1) 1];
    allPaths = path;
    currPath = path;
    currDir = start_dir;
    remScore = score;
    oneToFour = 1:4;
    while true
        endPoint = currPath(1);
        possible_dirs = input(endPoint + dirs) ~= '#';
        possible_dirs_ind = oneToFour(possible_dirs);
        % dont turn back 180 degrees.
        possible_dirs_ind = possible_dirs_ind(oneToFour(possible_dirs) == currDir | mod(currDir-2,2) ~= mod(oneToFour(possible_dirs),2));
        if numel(possible_dirs_ind)>1
            pdirDir = dirs(possible_dirs_ind);
            for p=possible_dirs_ind
                % do we have to turn?
                testScore = remScore;
                if p ~= currDir
                    testScore = testScore - 1000; 
                end
                curDirDir = dirs(p);
                % block the other directions in input
                blockedPos = endPoint + pdirDir(pdirDir~=curDirDir);
                blockedInput = input;
                blockedInput(blockedPos) = '#';
                [score, path] = minScoreFromStartToFin(blockedInput, endPoint, fin_pos, p, 3, testScore); % must end with east
                if score == testScore
                    % we found something of the same length. Is this
                    % already the path we know?
                    if ~all(currPath == flip(path))
                        % we found a new path. Find all paths from this
                        % point on
                        new_paths = findAllPathsFromStartToFin(blockedInput, endPoint, fin_pos, p, 3, score, fliplr(path));
                        allPaths = unique([allPaths new_paths]);
                    else
                        currDir = p;
                        remScore = score;
                    end
                end
            end
        else
            % did we turn?
            if currDir ~= possible_dirs_ind
                % yes
                remScore = remScore - 1000;
                currDir = possible_dirs_ind;
            end
        end
        remScore = remScore - 1;
        currPath = currPath(2:end);
        if length(currPath) == 1
            if currPath == fin_pos
                return
            else
                todo = 1;
            end
        end
    end
end