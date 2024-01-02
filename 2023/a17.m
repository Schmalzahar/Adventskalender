input = char(readlines("a17.txt"))-'0';
tic
start_pos = 1;
fin = numel(input);
switch 1
    case 1
        minSteps = 1;
        maxSteps = 3;
    case 2
        minSteps = 4;
        maxSteps = 10;
end

dirs = [1;height(input);-1;-height(input)]; %down right up left: 1 2 3 4
numDirs = size(dirs,1);

% minCost will record the cost needed to reach the goal position, assuming
% you're already in that state
minCost = inf([numel(input),numDirs,maxSteps]);
% If you're at the goal position, there is zero cost remaining
minCost(start_pos,:,minSteps:maxSteps) = 0;
[di,st] = ndgrid([1 2],minSteps:maxSteps); % at the start, only down and right possible
needsUpdating = [ones(2*(maxSteps-minSteps+1),1), di(:), st(:)];

% save the path
bestPath = repmat({double.empty(0,1)}, size(minCost));

% showMatrices(minCost, input)

while ~isempty(needsUpdating)

    % Make sure the needsUpdating is unique so we don't repeat operations
	needsUpdating = unique(needsUpdating,'rows');    

    newNeedsUpdating = double.empty(0,3);

    for k=1:size(needsUpdating,1)
        toUpdate = needsUpdating(k,:);

        currPos = toUpdate(1);
        dir = toUpdate(2);
        numSteps = toUpdate(3);

        
        switch mod(currPos,height(input))
            case 0 % if we are at the last row, we cannot move down
                if dir == 1
                    continue
                end
            case 1 % if we are at the first row, we wannot move up
                if dir == 3
                    continue
                end
        end
        if currPos <= height(input) && dir == 4
            continue % if we are at the first col, we cannot move left
        end
        if currPos >= (numel(input)-height(input)+1) && dir == 2
            continue % if we are at the last col, we cannot move right
        end

        newPos = currPos + dirs(dir);

        costToMoveToDest = input(newPos);
        proposedCost = minCost(currPos,dir,numSteps) + costToMoveToDest;
        proposedBestPath = [currPos; bestPath{currPos, dir, numSteps}];

        % If numSteps>1, we have to continue in that direction
        if numSteps > 1 % completely locked in
            % Only one case
            newDirs = dir;
            newNumSteps_ = numSteps - 1;
        else
            % we can go left or right (relative to current dir)
            newDirs = mod(dir + [-1,+1]-1,numDirs)+1;
            % All numSteps are valid 
            newNumSteps_ = minSteps:maxSteps;
        end

        % Propagate each of these cases separately
        for newDir = newDirs
            for newNumSteps = newNumSteps_
                
                priorMinCost = minCost(newPos,newDir, newNumSteps);
                if proposedCost < priorMinCost
                    minCost(newPos, newDir, newNumSteps) = proposedCost;
                    bestPath{newPos, newDir, newNumSteps} = proposedBestPath;
                    newNeedsUpdating(end+1,:) = [newPos, newDir, newNumSteps];
                end
            end
        end
    end
    needsUpdating = newNeedsUpdating;
    % showMatrices(minCost, input)
end

% Select the best option
minCostFull = inf;
bestPathFull = double.empty(0,1);
for dirInd = 1:numDirs
    for numSteps = 1:maxSteps
        proposedMinCost = minCost(fin, dirInd, numSteps);
        if proposedMinCost < minCostFull
            minCostFull = proposedMinCost;
            bestPathFull = bestPath{fin, dirInd, numSteps};
        end
    end
end
minCostFull
toc
%%
figure;
imagesc(input);
daspect([1,1,1])
colormap(hot)
hold on
[r,c] = ind2sub(size(input),bestPathFull);
plot(c,r,'bo','LineWidth',5);
% huh, there's apparently multiple minimum paths for the example...

function showMatrices(minCost, input)
	persistent f2
	if isempty(f2) || ~isvalid(f2)
		f2 = figure(2);
	end
	dirs = {'down','right','up','left'};
	cap = max(minCost(:));
	colormap(flipud(hot))
	k = 1;
	for depth = 1:size(minCost,3)
		for dirInd = 1:4
			ax = subplot(size(minCost,3),4,k,'Parent',f2);
			imagesc( reshape(minCost(:,dirInd,depth),height(input),width(input)), 'Parent',ax);
			caxis([0,cap])
			daspect(ax,[1,1,1])
			k = k + 1;
			if depth==1
				title(ax,dirs{dirInd});
			end
		end
	end
	drawnow limitrate
end