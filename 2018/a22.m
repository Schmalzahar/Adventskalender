input = readlines("a22.txt");
depth = input(1).extract(digitsPattern).double;
m = 20183;
target = input(2).extract(digitsPattern).double';
geo = NaN(target(1)+20,target(2)+20);
geo(1,1) = 0;
geo(:,1) = mod((0:height(geo)-1) .* 16807,m);
geo(1,:) = mod((0:width(geo)-1) .* 48271,m);
ero = mod(geo + depth,m);

for i=2:width(geo)
    for j=2:height(geo)
        if j == target(1)+1 && i == target(2)+1
            geo(j,i) = 0;
            ero(j,i) = mod(geo(j,i) + depth,m);
        else
            geo(j,i) = mod(ero(j-1,i) * ero(j,i-1),m);
            ero(j,i) = mod(geo(j,i) + depth,m);
        end
    end
end

region = mod(ero,3);

pmap = char(zeros(size(region')));
pmap((region == 0)') = '.'; % rocky
pmap((region == 1)') = '='; % wet
pmap((region == 2)') = '|'; % narrow
pmap(target(2)+1,target(1)+1) = 'G';

sum(region(1:target(1)+1,1:target(2)+1),'all')
%% part 2: pathfinding
tic
loc = [1, 1];
queue = PriorityQueue();
eq = 1; % 1: torch, 2: climb gear, 3: neither

queue.push([loc eq], 0);

% every position of the map can be visited with two possible equipments. If
% one path reaches one postion in a shorter time with the same equipment,
% then it is a better path
dist = Inf(3,height(region),width(region));
prev = zeros(size(dist));
dist(eq,loc(1),loc(2)) = 0;
allowed = [1 2;2 3;1 3];

while ~isempty(queue.items)
    [cur,c] = queue.pop();
    eq = cur(3); cur = cur(1:2);
    % get the next possible steps
    op = getLocs(cur, region);
    % process steps
    for i=1:height(op)
        o = op(i,:);
        creg = region(cur(1),cur(2));
        nreg = region(o(1),o(2));
        for j=1:3
            if ismember(j, allowed(nreg+1,:))
                if j == eq
                    d = 1; % no switching
                elseif ismember(j, allowed(creg+1,:))
                    d = 8; % 1 switching needed
                else
                    d = 15; % 2 switches needed
                end
            else
                continue
            end
            new_dist = c + d;
            if dist(j,o(1),o(2)) > new_dist
                dist(j,o(1),o(2)) = new_dist;
                prev(j,o(1),o(2)) = sub2ind(size(dist),eq,cur(1),cur(2));
                queue.push([o(1),o(2),j],new_dist);
            end      
        end
    end
end

dist(1,target(1)+1,target(2)+1)
% plotPath(target, prev, pmap)
toc

function plotPath(target ,prev, pmap)
pr = prev(1,target(1)+1,target(2)+1);
while true
    [a,b,c] = ind2sub(size(prev),pr);
    switch a
        case 1
            ch = 'T'; % torch
        case 2
            ch = 'C'; % Climb
        case 3
            ch = 'N'; % neither
    end
    pmap(c,b) = ch;
    if a == 0
        break
    end
    pr = prev(a,b,c);
end
pmap
end

function out = getLocs(loc, pmap)
out = [];
if loc(1) ~= 1
    out(end+1,:) = [loc(1)-1 loc(2)];
end
if loc(1) ~= height(pmap)
    out(end+1,:) = [loc(1) + 1 loc(2)];
end
if loc(2) ~= 1
    out(end+1,:) = [loc(1) loc(2)-1];
end
if loc(2) ~= width(pmap)
    out(end+1,:) = [loc(1) loc(2) + 1 ];
end
end