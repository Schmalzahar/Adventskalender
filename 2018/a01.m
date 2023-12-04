tic
input = str2double(readlines("a01.txt"));
s = sum(input)
frequencies = 0;
i = 1;
l = length(input);
for i=1:l
    frequencies = [frequencies; frequencies(end)+input(i)];
end
frequencies = frequencies(2:end);
while true
    frequencies = [frequencies; frequencies(end-l+1:end)+s];
    if length(unique(frequencies)) ~= length(frequencies)
        break
    end
end
frequencies = frequencies(1:end-l);
for i=1:l
    frequencies = [frequencies; frequencies(end)+input(i)];
    if length(unique(frequencies)) ~= length(frequencies)
        break
    end
end
frequencies(end)
toc