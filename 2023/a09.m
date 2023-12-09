input = readlines("a09.txt");
new_end_val = [];
new_first_val = [];
for i=1:size(input,1)
    line = input(i).split(' ').double';
    new_vals = [line(1) line(end)];
    while ~all(line == 0)
        line = diff(line);
        new_vals = [new_vals; line(1) line(end)];
    end
    new_end_val = [new_end_val ; sum(new_vals(:,2))];
    new_first_val = [new_first_val; sum((-1).^((1:length(new_vals(:,1)))+1).*new_vals(:,1)')];
end
sum(new_end_val)
sum(new_first_val)