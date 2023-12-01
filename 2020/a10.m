input = readmatrix("input_10.txt");
device = max(input) + 3;
dat = sort([0;input;device]);
diffs = diff(sort(dat));
res = sum(diffs==1) * sum(diffs==3);
disp("Result part 1: "+res)
% Part 2
dist_ar = 1;
new_block = [];
for i=1:height(dat)-1
    new_block(end+1,1) = dat(i);
    if dat(i+1) == 3 + dat(i)
        if height(new_block)>2
            dist_ar = dist_ar * getMulti(height(new_block));
        end
        new_block = [];
    end
end
s = sprintf('Result part 2: %d',dist_ar);
disp(s)
function m = getMulti(len)
    switch len
        case 3
            m = 2; % 2^1
        case 4
            m = 4; % 2^2
        case 5
            m = 7; % 2^3 - 1
    end
end