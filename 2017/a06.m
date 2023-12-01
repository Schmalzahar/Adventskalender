tic
line = str2double(strsplit(readlines("a06.txt")));
states = keyHash(join(string(line)));
cycles = 0;
while true
    [a,b] = max(line);
    line(b) = 0;
    while true
        b = mod(b, length(line)) + 1;
        line(b) = line(b) + 1;
        a = a - 1;
        if a == 0
            break
        end
    end
    cycles = cycles + 1;
    
    if ismember(keyHash(join(string(line))),states)
        size(states,1) - (find(keyHash(join(string(line))) == states)-1)
        break
    else
        states = [states; keyHash(join(string(line)))];
    end    
end
toc