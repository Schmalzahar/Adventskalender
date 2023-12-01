%% Day 9.1
string_map = readmatrix("input_a09.txt","OutputType","string");
map = zeros(size(string_map,1),strlength(string_map(1,1)));
for i=1:size(string_map,1)
    line = string_map(i);
    map(i,:) = str2double(regexp(line,'.','match'));
end
mins = imregionalmin(map,4);
result = sum(map(mins)+1)
%% 9.2: basins: find the three largest basins and multiply their sizes
basins = map ~= 9;
[basin_info,n] = bwlabel(basins,4);
% find the largest three basins
basin_size=zeros(n,1);
for i=1:n
    basin_size(i)=sum(sum(basin_info==i));
end
max3 = maxk(basin_size,3);
result2 = prod(max3)