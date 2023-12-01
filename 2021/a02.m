%% Day 2 part 1 and 2
data = readmatrix("input_a02.txt","OutputType","string");
aim = 0;
horizontal = 0;
depth = 0;
for i=1:size(data,1)
    switch data(i,1)
        case "forward"
            horizontal = horizontal + str2double(data(i,2));
            depth = depth + aim * str2double(data(i,2));
        case "down"
            aim = aim + str2double(data(i,2));
        case "up"
            aim = aim - str2double(data(i,2));
    end
end
disp("Result 1: "+horizontal * aim+", result 2: "+horizontal * depth)