%% Day 20
% part 1: 10:06-11:11
% part 2: 11:11-11:38
key = 811589153;
lines = str2double(readlines("a20.txt"))';
og_lines = lines;
indices = 1:length(lines);
for j=1:10
    for i=1:length(lines)
        num = og_lines(i);
        num = num * key;
        I = find(indices == i);
        if num == 0
            continue
        end
        new_i = I + num;
        new_i = mod(new_i,length(lines)-1);
        if new_i < 1
            new_i = length(lines) + new_i - 1;
        end
        if I == 1
            indices = [indices(2:(new_i)), i, indices(new_i+1:end)];
        elseif I < length(lines)
            temp_ind = indices(~(indices == i));
            indices = [temp_ind(1:new_i-1), i, temp_ind(new_i:end)];
        else
            indices = [indices(1:(new_i-1)), i, indices(new_i:end-1)];
        end
        
    end
%     og_lines(indices) * key;
end
lines = og_lines(indices);
% find the 0
zero_ind = find(lines == 0);
sum = 0;
for n = [1000, 2000, 3000]
    ind = mod(n, length(lines));
    ind = zero_ind + ind;
    if ind > length(lines)
        ind = ind - length(lines);
    end
    sum = sum + lines(ind)* key;
end
sprintf('%12.f',sum)