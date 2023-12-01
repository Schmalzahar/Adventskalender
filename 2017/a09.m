input = char(readlines("a09.txt"));
score = 0;
depth = 0;
i = 1;
garbage = 0;
char_count = 0;
while true
    ch = input(i);
    if garbage == 0
        if strcmp(ch,'{')
            depth = depth + 1;  
            score = score + depth;              
        elseif strcmp(ch,'}')
            depth = depth - 1;
        elseif strcmp(ch,'<')
            garbage = 1;
         end
    else
        if strcmp(ch,'>')
            garbage = 0;
        elseif strcmp(ch,'!')
            i = i+1;
        else
            char_count = char_count + 1;
        end
    end
    i = i+1;
    if i > length(input)
        break
    end
end
score
char_count