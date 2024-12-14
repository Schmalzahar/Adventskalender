input = readlines("a14.txt");

sx = 101; sy = 103;
robot_map = zeros([sx sy size(input,1)]);

robot_info = arrayfun(@(x) regexp(x,"p=(\d*),(\d*) v=(-?\d*),(-?\d*)",'tokens'), input);
pos = zeros(size(input,1),2); vel = zeros(size(pos));
for i=1:size(input,1)
    pos(i,:) = str2double(robot_info{i}(1:2))+1;
    vel(i,:) = str2double(robot_info{i}(3:4));
    robot_map(pos(i,1),pos(i,2),i) = 1;
end

for s=1:7916
    [robot_map, pos] = oneSec(robot_map, pos, vel);
    count_map = fliplr(rot90(sum(robot_map,3),-1));
    if s == 100
        part1 = sum(count_map(1:floor(sy/2),1:floor(sx/2)),'all') * ...
            sum(count_map(1:floor(sy/2),ceil(sx/2)+1:end),'all') * ...
            sum(count_map(ceil(sy/2)+1:end,1:floor(sx/2)),'all') * ...
            sum(count_map(ceil(sy/2)+1:end,ceil(sx/2)+1:end),'all')
    end
end

count_map = fliplr(rot90(sum(robot_map,3),-1));
imagesc(count_map)

% why 7916: there are events when the map is aligned horizontally and
% vertically. In one direction its 38+x*101, the other its 88+y*103. 7916
% is when both align at the same time for the first time.


function [updated_map, updated_pos] = oneSec(robot_map, pos, vel)
    [sx, sy, num_robs] = size(robot_map);
    updated_map = zeros([sx, sy, num_robs]);
    updated_pos = zeros(size(pos));
    for i=1:num_robs
        new_pos_x = pos(i,1) + vel(i,1);
        if new_pos_x > sx
            new_pos_x = new_pos_x - sx;
        elseif new_pos_x < 1
            new_pos_x = new_pos_x + sx;
        end
        new_pos_y = pos(i,2) + vel(i,2);
        if new_pos_y > sy
            new_pos_y = new_pos_y - sy;
        elseif new_pos_y < 1
            new_pos_y = new_pos_y + sy;
        end   
        updated_pos(i,:) = [new_pos_x, new_pos_y];
        updated_map(updated_pos(i,1),updated_pos(i,2),i) = 1;
    end    
end
