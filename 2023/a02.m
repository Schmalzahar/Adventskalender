input = readlines("a02.txt");
red = 12;
green = 13;
blue = 14;
res = 0;
power = 0;
for i=1:length(input)
    line = input(i);
    line1 = strsplit(line,': ');
    line2 = strsplit(line1(2),'; ');
    correct = 0;
    max_red = 0;
    max_green = 0;
    max_blue = 0;
    for j=1:length(line2)
        revealed = line2(j);
        red_drawn = str2double(regexp(revealed,'(\d+) red','tokens','once'));
        green_drawn = str2double(regexp(revealed,'(\d+) green','tokens','once'));
        blue_drawn = str2double(regexp(revealed,'(\d+) blue','tokens','once'));
        if ((isempty(red_drawn) || (red_drawn <= red)) && (isempty(green_drawn) || (green_drawn<=green))) && (isempty(blue_drawn) || blue_drawn<=blue)
            correct = correct + 1;
        end       
        if red_drawn > max_red
            max_red = red_drawn;
        end
        if green_drawn > max_green
            max_green = green_drawn;
        end
        if blue_drawn > max_blue
            max_blue = blue_drawn;
        end
    end
    if correct == length(line2)
        res = res + i;
    end
    power = power + max_red*max_green*max_blue;
end
res
power