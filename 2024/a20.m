input = char(readlines("a20.txt"));
start_pos = find(input == 'S');
fin = find(input == 'E');

[s,t] = buildGraph(input);
G = graph(s,t);
P = shortestpath(G,start_pos,fin);
origLen = numel(P)-1;

%% part 1/2
tracker = configureDictionary("double","double");
path = find(input ~= '#');
[px, py] = ind2sub(size(input), path);
maxDistance = 20;
cache = configureDictionary("double","double");
for i=1:numel(path)
    distances = abs(px - px(i)) + abs(py - py(i));
    ind1 = distances <= maxDistance & distances > 1;
    inRange = [px(ind1) py(ind1) distances(ind1)];

    for k=1:size(inRange,1)
        if isKey(cache, start_pos * 10000 + path(i))
            P1_1 = cache(start_pos * 10000 + path(i));
        else
            P1_1 = numel(shortestpath(G,start_pos,path(i))) - 1;
            cache(start_pos * 10000 + path(i)) = P1_1;
        end
        if isKey(cache, sub2ind(size(input),inRange(k,1),inRange(k,2)) * 10000 + fin)
            P1_2 = cache(sub2ind(size(input),inRange(k,1),inRange(k,2)) * 10000 + fin);
        else
            P1_2 = numel(shortestpath(G,sub2ind(size(input),inRange(k,1),inRange(k,2)),fin)) - 1;
            cache(sub2ind(size(input),inRange(k,1),inRange(k,2)) * 10000 + fin) = P1_2;
        end
        
        l = P1_1 + P1_2 + inRange(k,3);
        if l <= origLen - 100
            if isKey(tracker, origLen - l)
                tracker(origLen - l) = tracker(origLen - l) + 1;
            else
                tracker(origLen - l) = 1;
            end
        end
    end
end

sum(tracker.values)

function [s,t] = buildGraph(grid)
    s = []; t = [];
    sz = size(grid,1);
    dirs = [1 0; -1 0; 0 -1; 0 1];
    for idx = 1:numel(grid)
        if grid(idx) ~= '#'
            [r,c] = ind2sub(size(grid),idx);
            r = r + dirs(:,1); c = c + dirs(:,2);
            valid = (r >= 1 & r <= sz & c >= 1 & c <= sz);
            r = r(valid); c = c(valid);
            idx_neigh = sub2ind(size(grid), r, c);
            b = sum(grid(idx_neigh) ~= '#');
            s(end+1:end+b) = idx;
            t(end+1:end+b) = idx_neigh(grid(idx_neigh) ~= '#');
        end
    end    
end