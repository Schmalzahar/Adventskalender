%% day 11
a = readlines("a11.txt");
items = [];
operation = [];
test = [];
true_monkey = [];
false_monkey = [];
i = 1;
while true
    items = [items, str2double(extract(a(i+1), digitsPattern))];
    t2 = strsplit(a(i+2),': ');
    operation = [operation, t2(2)];
    true_monkey = [true_monkey, str2double(extract(a(i+3), digitsPattern))];
    false_monkey = [false_monkey, str2double(extract(a(i+4), digitsPattern))];
    i = i+7;
    if i>length(a)
        break
    end

end