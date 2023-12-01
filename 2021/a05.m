%% Day 5.1
data = readmatrix("input_a05.txt","OutputType","string");
% lines are represented as an nx4 array
lines = NaN(size(data,1),4);
lines(:,1) = str2double(data(:,1));
lines(:,2:3) = reshape(cell2mat(cellfun(@str2double,arrayfun(@(x) split(x,"->"),data(:,2),'UniformOutput',false),'UniformOutput',false)),[2,size(data,1)])';
lines(:,4) = str2double(data(:,3));
% Discard diagonal lines
sorted = hv(lines);
% create the map. It is a square with the size of the max(max(sorted)) and
% min(min(sorted)
map = zeros(max(max(sorted))+1);
% Project the lines onto the map. Each occurence is marked on the map as an
% increase in the number
for i=1:size(sorted,1)
    map = applyLine(map,sorted(i,:));
end
% count the points larger than 2
result = sum(sum(map>=2));
disp("The result is: "+result)
function sorted = hv(lines)
    aufgabe = "5.2";
    switch aufgabe
        case "5.1"
            % first horizontal lines
            x1 = lines(:,1);
            x2 = lines(:,3);
            hor = x1==x2;
            y1 = lines(:,2);
            y2 = lines(:,4);
            ver = y1==y2;
            sorted = lines(hor | ver,:);
        case "5.2"
            sorted=lines;
    end
end

function map = applyLine(map,line)
    x1 = line(1);
    y1 = line(2);
    x2 = line(3);
    y2 = line(4);
    if x2<x1
        x = x1:-1:x2;
    else
        x = x1:x2;
    end
    if y2<y1
        y = y1:-1:y2;
    else
        y = y1:y2;
    end
    if length(y) < length(x)
        y = y*ones(1,length(x));
    elseif length(y) > length(x)
        x = x*ones(1,length(y));
    end
    points = [x;y]';
    for i=1:size(points,1)
        map(points(i,2)+1,points(i,1)+1) = map(points(i,2)+1,points(i,1)+1)+1;
    end
end