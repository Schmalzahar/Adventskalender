%% Day 14
% part 1: 08:39-09:20
% part 2: 09:20-09:33
a = readlines("a14.txt");
sx = 500; sy = 0;
width = 200;
max_depth = 200;
area = ones(max_depth+1, 2*width+1)*2; % air is 2
area(sy+1,sx-500+width+1) = 0; % sand is 0
lowest_rock = 0;

part = 1;

% map out cave
for i=1:height(a)
    line = a(i);
    digits = str2double(extract(line, digitsPattern));
    for j=1:length(digits)/2-1
        x1 = digits(2*j-1);
        x2 = digits(2*(j+1)-1);
        if x2<x1
            t = x1;
            x1 = x2;
            x2 = t;
        end
        y1 = digits(2*j);    
        if y1 > lowest_rock
            lowest_rock = y1;
        end
        y2 = digits(2*(j+1));
        if y2 > lowest_rock
            lowest_rock = y2;
        end
        if y2<y1
            t = y1;
            y1 = y2;
            y2 = t;
        end
        area(1+(y1:y2),width-500+1+(x1:x2)) = 1;
    end
end
%  part 2
floor = lowest_rock + 3;
area(floor,:) = 1;

% pour sand
void = false;
n = 0;
while ~void
    moving = true;
    s1x = sx-500+width+1;
    s1y = sy+1;
    while moving        
        if s1y > lowest_rock && part == 1
            moving = false;
            void = true;
            n = n-1;
            break
        end
        % check 1 down
        if area(s1y+1, s1x) == 2
            s1y = s1y + 1;
            continue
        end
        % check down left
        if area(s1y+1, s1x-1) == 2
            s1y = s1y + 1;
            s1x = s1x - 1;
            continue
        end
        % check down right
        if area(s1y+1, s1x+1) == 2
            s1y = s1y + 1;
            s1x = s1x + 1;
            continue
        end
        if s1y == sy+1 && s1x == sx-500+width+1 && part == 2
            void = true;
            moving = false;
            break
        end
        % Rest
        area(s1y, s1x) = 0;
        moving = false;
    end
    n = n+1;
end
n
imshow(area,[0 2])