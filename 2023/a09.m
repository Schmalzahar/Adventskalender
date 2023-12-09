input = readlines("a09.txt");
new_end_val = [];
new_first_val = [];
for i=1:size(input,1)
    line = input(i).split(' ').double';
    last_val = line(end);
    first_val = line(1);
    while ~all(line == 0)
        line = diff(line);
        last_val = [last_val; line(end)];
        first_val = [first_val; line(1)];
    end
    new_end_val = [new_end_val ; sum(last_val)];
    new_first_val = [new_first_val; sum((-1).^((1:length(first_val))+1).*first_val')];
end
sum(new_end_val)
sum(new_first_val)