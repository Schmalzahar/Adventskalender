passes = readlines("input_05.txt");
highest_id = 0;
all_ids = [];
for i=1:height(passes)
    pass = char(passes(i));
    range = 0:127;
    for j=1:7
        if pass(j) == 'F'
            range = range(1:end/2);
        else
            range = range(end/2+1:end);
        end
    end
    row = range;
    range = 0:7;
    for j=8:10
        if pass(j) == 'L'
            range = range(1:end/2);
        else
            range = range(end/2+1:end);
        end
    end
    column = range;
    id = row*8+column;
    all_ids(end+1,1) = id;
    if id > highest_id
        highest_id = id;
    end
end
highest_id
my_id = find(~ismember(min(all_ids):max(all_ids),all_ids)) + min(all_ids) - 1