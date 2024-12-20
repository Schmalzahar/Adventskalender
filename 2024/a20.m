input = char(readlines("a20.txt"));
tic
start_pos = find(input == 'S');
fin = find(input == 'E');
[sorted, indices] = sortIndices(input, start_pos, fin);
origLen = size(sorted,1) - 1;

%% part 1/2
tracker = configureDictionary("double","double");
path = find(input ~= '#');
[px, py] = ind2sub(size(input), path);
maxDistance = 20;
cache = configureDictionary("double","double"); % "find" is pretty slow
for i=1:numel(path)
    distances = abs(px - px(i)) + abs(py - py(i));
    ind1 = distances <= maxDistance & distances > 1;
    inRange = [px(ind1) py(ind1) distances(ind1)];

    for k=1:size(inRange,1)
        P1_1 = indices(i)-1;
        if isKey(cache, sub2ind(size(input),inRange(k,1),inRange(k,2)) * 10000 + fin)
            P1_2 = cache(sub2ind(size(input),inRange(k,1),inRange(k,2)) * 10000 + fin);
        else
            P1_2 = size(sorted,1) - find(all(sorted == inRange(k,1:2),2));
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
toc

function [sorted, indices] = sortIndices(input, start, fin)
    dirs = [1 0; -1 0; 0 -1; 0 1];
    [px, py] = find(input ~= '#');
    path = find(input ~= '#');
    [rs,cs] = ind2sub(size(input),start);
    sorted = zeros(size(px,1),2);
    sorted(1,:) = [rs cs];
    for i=2:size(px,1)-1
        neigh = sorted(i-1,:) + dirs;
        valid = all(neigh >= 1 & neigh <= size(input,1),2);
        neigh = sub2ind(size(input),neigh(valid,1), neigh(valid,2));
        neigh = neigh(input(neigh) ~= '#');
        [a,b] = ind2sub(size(input), neigh);
        if i>2
            id1 = any([a,b] ~= sorted(i-2,:),2);
        else
            id1 = 1;
        end
        sorted(i,:) = [a(id1),b(id1)];
    end
    [rf,cf] = ind2sub(size(input),fin);
    sorted(end,:) = [rf cf];

    sorted_ind = sub2ind(size(input),sorted(:,1),sorted(:,2));
    [~,indices] = ismember(path, sorted_ind);
end