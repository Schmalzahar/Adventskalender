input = str2double(extract(readlines("a18.txt"),digitsPattern))+1;
sz = 71;
grid = zeros(sz);

%% part 1
tic
grid(sub2ind(size(grid), input(1:1024,2), input(1:1024,1))) = 1;
[s,t] = buildGraph(grid);
G = graph(s,t);
P = shortestpath(G,1,numel(grid));
tgrid = grid; tgrid(P) = 2;
imagesc(tgrid)
part1 = length(P)-1
toc

%% part 2
tic
grid = zeros(sz);
grid(sub2ind(size(grid), input(:,2), input(:,1))) = 1;

[s,t] = buildGraph(grid);
for i=size(input,1):-1:1
    r = input(i,2); c = input(i,1);
    idx = sub2ind(size(grid), r, c);
    grid(idx) = 0;        
    r = r + dirs(:,1); c = c + dirs(:,2);
    valid = (r >= 1 & r <= 71 & c >= 1 & c <= 71);
    r = r(valid); c = c(valid);
    idx_neigh = sub2ind(size(grid), r, c);
    b = sum(grid(idx_neigh) == 0);
    s(end+1:end+b) = idx;
    t(end+1:end+b) = idx_neigh(grid(idx_neigh) == 0);

    G = graph(s,t);    
    P = shortestpath(G,1,numel(grid));
    if ~isempty(P)
        tgrid = grid; tgrid(P) = 2;
        figure()
        imagesc(tgrid)
        sprintf('Part2: %d,%d',input(i,:)-1)
        break
    end
end
toc

function [s,t] = buildGraph(grid)
    s = []; t = [];
    sz = size(grid,1);
    dirs = [1 0; -1 0; 0 -1; 0 1];
    for idx = 1:numel(grid)
        if grid(idx) == 0
            [r,c] = ind2sub(size(grid),idx);
            r = r + dirs(:,1); c = c + dirs(:,2);
            valid = (r >= 1 & r <= sz & c >= 1 & c <= sz);
            r = r(valid); c = c(valid);
            idx_neigh = sub2ind(size(grid), r, c);
            b = sum(grid(idx_neigh) == 0);
            s(end+1:end+b) = idx;
            t(end+1:end+b) = idx_neigh(grid(idx_neigh) == 0);
        end
    end    
end