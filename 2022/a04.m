%% Day 4
% part 1 ~20min
% part 2 ~10min
pairs = readlines("a04.txt");
fully_contained = 0;
overlap = 0;
for i=1:height(pairs)
    pair = regexp(pairs(i),'(\d+)-(\d+),(\d+)-(\d+)','tokens');
    elves = str2double(pair{:});
    elve1 = elves(1:2);
    elve2 = elves(3:4);
    if (elve1(1)<=elve2(1) && elve1(2) >= elve2(2)) || (elve2(1)<=elve1(1) && elve2(2) >= elve1(2))
        fully_contained = fully_contained + 1;
    end

    if (elve1(2)>=elve2(1) && elve2(2)>=elve1(1))
        overlap = overlap + 1;
    end
end
disp(fully_contained)
disp(overlap)