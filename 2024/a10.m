input = char(readlines("a10.txt"))-'0';
[zx, zy] = find(input == 0);
part1 = 0;
part2 = 0;
for i=1:numel(zx)
    [trail, allPaths] = findNines(zx(i), zy(i), input, [], [posx posy], []);
    part1 = part1 + size(trail,1);
    part2 = part2 + size(allPaths,3);
end
part1
part2

function [trail, allPaths] = findNines(posx, posy, input, trail, path, allPaths)
    if input(posx, posy) == 9
        allPaths = cat(3,allPaths,path);        
        if isempty(trail) || ~any(all(trail == [posx posy],2))
            trail = [trail; posx posy];
        end
        return
    end
    ap = around_pos(posx, posy, input);
    for k=1:size(ap,1)
        if input(ap(k,1),ap(k,2)) - input(posx,posy) == 1
            [trail, allPaths] = findNines(ap(k,1), ap(k,2), input, trail, [path; ap(k,1) ap(k,2)], allPaths);
        end
    end
end

function out = around_pos(x,y,map)
    out = [x+1 y;x-1 y; x y+1; x y-1];
    out(any(out == 0,2),:) = [];
    out(any(out > size(map,1),2),:) = [];
end