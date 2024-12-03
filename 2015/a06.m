input = readlines("a06.txt");
map = false(1000,1000);
map2 = zeros(1000,1000);
% imshow(map)
% hold on
for i=1:size(input,1)
    line = char(input(i));
    nums = str2double(extract(line,digitsPattern))+1; % +1 because matlab
    if line(6:7) == 'on'
        map(nums(1):nums(3),nums(2):nums(4)) = true;
        map2(nums(1):nums(3),nums(2):nums(4)) = map2(nums(1):nums(3),nums(2):nums(4)) + 1;
    elseif line(6:7) == 'of'
        map(nums(1):nums(3),nums(2):nums(4)) = false;
        temp = map2(nums(1):nums(3),nums(2):nums(4));
        temp(temp == 0) = 1;
        map2(nums(1):nums(3),nums(2):nums(4)) = temp - 1; % minimum of zero
    else
        map(nums(1):nums(3),nums(2):nums(4)) = ~map(nums(1):nums(3),nums(2):nums(4));
        map2(nums(1):nums(3),nums(2):nums(4)) = map2(nums(1):nums(3),nums(2):nums(4)) + 2;
    end
    % imshow(map)
end
part1 = sum(map,'all')
part2 = sum(map2,'all')