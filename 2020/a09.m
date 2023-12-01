input = readmatrix("input_09.txt");
prev = 25;
i = prev;
while true
    next_num = input(i+1);
    sum_matrix = triu(input(1+i-prev:i)+input(1+i-prev:i)',1);
    if ~any(next_num == sum_matrix,'all')
        invalid_num = next_num;
        break
    end
    i = i+1;
end
invalid_num
%% Part 2
i=1;
set = [];
while true
    set(end+1) = input(i);
    while sum(set) > invalid_num
        set(1) = [];
    end
    if sum(set) == invalid_num
        break
    end
    i = i+1;
end
res = max(set)+min(set)