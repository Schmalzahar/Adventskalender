input = readlines("input_08.txt");
i = 1;
accumulator = 0;
visit = false(size(input));
while true
    line_spl = strsplit(input(i),' ');
    if ~visit(i)
        visit(i) = true;
    else
        break
    end
    switch line_spl(1)
        case "nop"
            i = i+1;
        case "acc"
            accumulator = accumulator + str2double(line_spl(2));
            i = i+1;
        case "jmp"
            i = i + str2double(line_spl(2));
    end
        
end
accumulator
%% Part 2
finished = false;
for j=1:height(input)
    i = 1;
    accumulator = 0;
    visit = false(size(input));
    if contains(input(j),"nop")
        if contains(input(j), "+0")
            continue
        end
        input(j) = strrep(input(j),"nop","jmp");
    elseif contains(input(j),"jmp")
        input(j) = strrep(input(j),"jmp","nop");
    else
        continue
    end

    while true
        if i>height(input)
            disp("Sucessfully terminated")
            accumulator
            finished = true;
            break
        end
        line_spl = strsplit(input(i),' ');
        if ~visit(i)
            visit(i) = true;
        else
            break
        end
        switch line_spl(1)
            case "nop"
                i = i+1;
            case "acc"
                accumulator = accumulator + str2double(line_spl(2));
                i = i+1;
            case "jmp"
                i = i + str2double(line_spl(2));
        end
            
    end    
    if contains(input(j),"jmp")
        input(j) = strrep(input(j),"jmp","nop");
    elseif contains(input(j),"nop")
        if contains(input(j), "+0")
            continue
        end
        input(j) = strrep(input(j),"nop","jmp");
    else
        continue
    end
    if finished
        break
    end
end