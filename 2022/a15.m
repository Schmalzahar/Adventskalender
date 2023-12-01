%% Day 15
% part 1: 08:32-09:51
% part 2: 09:51-13:38

a = readlines("a15.txt");
%% Second try
final_line = 2000000;
left = -5000000; right = 5000000;
beacon_line = zeros(1,right-left+1);
for i=1:height(a)
    line = char(a(i));
    digits = regexp(line,'Sensor at x=([-]?\d+), y=([-]?\d+): closest beacon is at x=([-]?\d+), y=([-]?\d+)','tokens');
    digits = str2double(digits{:});  
    distance = abs(digits(4)-digits(2))+abs(digits(3)-digits(1));
    % Check if this is relevant to final_line
    if (digits(2) > final_line && digits(2)-distance<=final_line) || (digits(2) < final_line && digits(2)+distance>=final_line)  || digits(2) == final_line
        distance_line_sensor = abs(digits(2)-final_line);
        num_of_marks_on_line = (distance - distance_line_sensor)*2 +1;
        indices = (digits(1)-left+1-floor(num_of_marks_on_line/2)):(digits(1)-left+1+floor(num_of_marks_on_line/2));
        beacon_line(1,indices) = 1;
        % remove possible beacon on line
        if digits(4) == final_line
            beacon_line(1,digits(3)-left+1) = 2;
        end
    end
end

sum(beacon_line==1)

%% Part 2
tic
digits = zeros(height(a),4);
for i=1:height(a)
    line = char(a(i));
    digits_temp = regexp(line,'Sensor at x=([-]?\d+), y=([-]?\d+): closest beacon is at x=([-]?\d+), y=([-]?\d+)','tokens');
    digits(i,:) = str2double(digits_temp{:});   
end

digits(:,5) = abs(digits(:,4)-digits(:,2))+abs(digits(:,3)-digits(:,1));

num = 4000000;
extra_dist = 1;
space = false;
while ~space
    for i=1:height(digits)
        c = rubyMatrix1(digits(i,5)+extra_dist);        
        for j=1:height(c)
            y = digits(i,2)+c(j,2)-digits(i,5)-extra_dist;
            x = digits(i,1)+c(j,1)-digits(i,5)-extra_dist;
            if isSpace(digits, y, x)
                if (num>=x) && (x>=0) && (num>=y) && (y>=0)
                    space = true;
                    break
                end
            end
        end
        if space
            break
        end
    end    
    extra_dist = extra_dist + 1;
end
result = x * 4000000 + y;
disp(result)
toc                                                             
function bool = isSpace(digits, down, right)
    bool = true;
    for i=1:height(digits)
        dist_point = abs(down-digits(i,2))+abs(right-digits(i,1));
        if dist_point <= digits(i,5)
            bool = false;
            break
        end
    end    
end

function c = rubyMatrix1(distance)
    middle = distance + 1;
    c = zeros(4*distance,2);
    % top to right
    c(1:distance,1) = ((middle):(middle+distance-1))-1;
    c(1:distance,2) = (1:(middle-1))-1;
    % right to bottom
    c((distance+1):(2*distance),1) = ((middle+distance):-1:(middle+1))-1;
    c((distance+1):(2*distance),2) = ((middle):(middle+distance-1))-1;
    % bottom to left
    c((2*distance+1):(3*distance),1) = ((middle):-1:(middle-distance+1))-1;
    c((2*distance+1):(3*distance),2) = ((middle+distance):-1:(middle+1))-1;
    % left to top
    c((3*distance+1):(4*distance),1) = ((middle-distance):1:(middle-1))-1;
    c((3*distance+1):(4*distance),2) = ((middle):1:(middle+distance-1))-1;
end