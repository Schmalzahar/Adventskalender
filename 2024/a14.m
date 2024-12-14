input = readlines("a14.txt");
tic
sx = 101; sy = 103;

robot_info = arrayfun(@(x) regexp(x,"p=(\d*),(\d*) v=(-?\d*),(-?\d*)",'tokens'), input);
pos = zeros(size(input,1),2); vel = zeros(size(pos));
for i=1:size(input,1)
    pos(i,:) = str2double(robot_info{i}(1:2))+1;
    vel(i,:) = str2double(robot_info{i}(3:4));
end

pos = [mod(pos(:,1)+100*vel(:,1)-1,sx)+1 mod(pos(:,2)+100*vel(:,2)-1,sy)+1]; 
robot_map = zeros([sx sy size(input,1)]);
for i=1:size(input,1)
    robot_map(pos(i,1),pos(i,2),i) = 1;
end
count_map = sum(robot_map,3);
part1 = sum(count_map(1:floor(sx/2),1:floor(sy/2)),'all') * ...
    sum(count_map(1:floor(sx/2),ceil(sy/2)+1:end),'all') * ...
    sum(count_map(ceil(sx/2)+1:end,1:floor(sy/2)),'all') * ...
    sum(count_map(ceil(sx/2)+1:end,ceil(sy/2)+1:end),'all')
%% part 2
s = 7916-100; % we already did 100 above
pos = [mod(pos(:,1)+s*vel(:,1)-1,sx)+1 mod(pos(:,2)+s*vel(:,2)-1,sy)+1];   

robot_map = zeros([sx sy size(input,1)]);
for i=1:size(input,1)
    robot_map(pos(i,1),pos(i,2),i) = 1;
end

imagesc(fliplr(rot90(sum(robot_map,3),-1)))
toc
% why 7916: there are events when the map is aligned horizontally and
% vertically. In one direction its every 38+x*101, the other direction its every
% 88+y*103. 7916 is when both align at the same time for the first time.