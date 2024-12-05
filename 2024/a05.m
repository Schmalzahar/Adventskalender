input = readlines("a05.txt");
rules = str2double(extract(input(1:find(input == "")-1),digitsPattern));
updates = input(find(input == "")+1:end);
nums = unique(rules);

correct = true(size(updates));
for u=1:size(updates,1)
    up = str2double(extract(updates(u),digitsPattern))';
    i = 1;
    cor = true;
    while cor
        a = up(i);
        [ax,ay] = find(rules == a);
        for k=i+1:numel(up)
            b = up(k);
            [bx, by] = find(rules == b);
            r = rules(ax(ismember(ax, bx)),:);
            if a ~= r(1)
                correct(u) = false;
                cor = false;
                break
            end
        end
        i = i+1;
        if i > numel(up) - 1
            break
        end
    end
end

true_up = updates(correct);
res = 0;
for l=1:numel(true_up)
    nt = str2double(extract(true_up(l), digitsPattern))';
    res = nt((numel(nt)-1)/2+1) + res;
end
res

%% part 2
% we are only interested in the number that ends up in the middle
% go through every number and see whether it can be in the middle
false_up = updates(~correct);
part2_res = 0;
for u=1:size(false_up,1)
    up = str2double(extract(false_up(u),digitsPattern))';
    lr_num = (numel(up)-1)/2;
    for i=1:numel(up)
        a = up(i);
        [ax,ay] = find(rules == a);
        left = numel(up(ismember(up,rules(ax(ay == 1),2))));
        right = numel(up(ismember(up,rules(ax(ay == 2),1))));
        if left == right && left == lr_num
            part2_res = part2_res + a;
        end
    end
end
part2_res