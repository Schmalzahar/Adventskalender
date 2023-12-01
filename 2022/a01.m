%% Day 1
% 10:17-10:55 part 1
% 10:55-10:57 part 2
a = str2double(readlines("a01.txt"));
line_breaks = isnan(a);
idx = 1+cumsum(line_breaks);
data = a(~line_breaks);
calories = accumarray(idx(~line_breaks),data);
disp("Most Calories carried by an elf: "+max(calories))
% part 2
disp("Calories carried by the top 3 elfes: "+sum(maxk(calories,3)))