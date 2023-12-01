input = readlines("input_12.txt");
% north: 0, east: 90, south: 180, west: 270
dir = 90;
east = 0;
north = 0;
for i = 1:height(input)
    line = char(input(i));
    switch line(1)
        case 'N'
            north = north + str2double(line(2:end));
        case 'E'
            east = east + str2double(line(2:end));
        case 'S'
            north = north - str2double(line(2:end));
        case 'W'
            east = east - str2double(line(2:end));
        case 'L'
            dir = dir - str2double(line(2:end));
        case 'R'
            dir = dir + str2double(line(2:end));
        case 'F'
            switch dir
                case 0
                    north = north + str2double(line(2:end));
                case 90
                    east = east + str2double(line(2:end));
                case 180
                    north = north - str2double(line(2:end));
                case 270
                    east = east - str2double(line(2:end));
            end
    end
    if dir >= 360
        dir = dir - 360;
    elseif dir < 0
        dir = dir + 360;
    end
end
res = abs(east) + abs(north)
%% Part 2
w_vec = [];
w_vec(1,1) = 10;
w_vec(2,1) = 1;
east = 0;
north = 0;
M = [0 -1;1 0];
for i = 1:height(input)
    line = char(input(i));
    switch line(1)
        case 'N'
            w_vec(2) = w_vec(2) + str2double(line(2:end));
        case 'E'
            w_vec(1) = w_vec(1) + str2double(line(2:end));
        case 'S'
            w_vec(2) = w_vec(2) - str2double(line(2:end));
        case 'W'
            w_vec(1) = w_vec(1) - str2double(line(2:end));
        case {'L' 'R'}
            if line(1) == 'L'
                sgn = 1;
            else
                sgn = -1;
            end
            w_vec = (sgn * M)^(str2double(line(2:end))/90) * w_vec;
        case 'F'            
            east = east + str2double(line(2:end)) * w_vec(1);
            north = north + str2double(line(2:end)) * w_vec(2);
    end
end
res = abs(east) + abs(north)