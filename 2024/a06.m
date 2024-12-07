input = char(readlines("a06.txt"));
tic
[path,~] = findPath(input);
part1 = sum(path == 'X','all')

% part 2
path(input == '^') = '^';
p = find(path == 'X');
loop_num = 0;
for i=1:numel(p)
    % try to palce a block and see what happens
    test_path = input; test_path(p(i)) = '#';
    [~, loop] = findPath(test_path);
    if loop
        loop_num = loop_num + 1;
    end
end
loop_num        
toc
function [input, loop] = findPath(input) 
    num_rot = 0;
    dirs = zeros([size(input),4]);
    while true
        [sx,sy] = find(input == '^');
        input(sx,sy) = 'X'; dirs(sx,sy,num_rot+1) = 1;
        block = find(input(1:sx-1,sy) == '#');
        if isempty(block)
            input(1:sx-1,sy) = 'X';
            loop = false;
            break
        else
            block = block(end);
        end        
        if any(dirs(block+1:sx-1,sy,num_rot+1) == 1)
            loop = true;
            break
        end
        input(block+1:sx-1,sy) = 'X'; 
        dirs(block+1:sx-1,sy,num_rot+1) = 1;
        input(block+1,sy) = '^';        
        input = rot90(input); dirs = rot90(dirs);
        num_rot = mod(num_rot + 1,4);
    end
    while num_rot ~= 0 % back to original position
        input = rot90(input);
        num_rot = mod(num_rot + 1,4);
    end
end

