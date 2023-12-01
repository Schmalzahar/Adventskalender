%% Day 5
% 07:30-08:47 part 1 (regex AAAAA)
% 08:47-08:53 part 2
part = 2;
input = readlines("a05.txt");
empty_line = 10;
starting_stacks = char(input(1:empty_line-1));
rearrangement = input(empty_line+1:end);
% read starting stack
stack_number = regexp(starting_stacks(end,:),'\d','match');
stack_number = str2double(stack_number(end));

stack = cell(1,stack_number);
for k=1:stack_number
    stack{k} = strrep(flip(starting_stacks(1:end-1,2+4*(k-1))'),' ','');
end

for i=1:height(rearrangement)
    command = str2double(regexp(rearrangement(i),"\d*",'match'));
    if part == 1
        for k=1:command(1)
            character = stack{command(2)}(end);
            stack{command(2)} = stack{command(2)}(1:end-1);
            stack{command(3)} = append(stack{command(3)},character);
        end
    elseif part == 2
        characters = stack{command(2)}(end-command(1)+1:end);
        stack{command(2)} = stack{command(2)}(1:end-command(1));
        stack{command(3)} = append(stack{command(3)}, characters);
    end
end
result = '';
for k=1:stack_number
    result = append(result,stack{k}(end));
end
result