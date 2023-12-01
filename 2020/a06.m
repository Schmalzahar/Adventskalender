input = readlines("input_06.txt");
input(end+1,1) = "";
count = 0;
line = "";
for i=1:height(input)    
    if input(i) ~= ""
        line = append(line,input(i));
    else
        count = count + length(unique(char(line)-'@'));
        line = "";
        continue
    end    
end
count
%% Part 2
count = 0;
line = -1;
for i=1:height(input)    
    if input(i) ~= ""
        if line == -1
            line = char(input(i))-'@';
        else
            line = line(ismember(line,char(input(i))-'@'));
        end
    else
        count = count + length(line);
        line = -1;
        continue
    end    
end
count