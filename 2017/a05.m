list = str2double(readlines("a05.txt"));
i = 1;
steps = 1;
while true
    line = list(i);
    i_new = i + line;
    if line > 2
        list(i) = line - 1;
    else
        list(i) = line + 1;
    end
    i = i_new;
    if i<1 || i>length(list)
        break
    end
    steps = steps + 1;
end
steps