input = readlines("input_16.txt");
tic
del = find(input == "");
rules = input(1:del(1)-1);
my_tickets = str2double(strsplit(char(input(del(1)+2:del(2)-1)),','));
nearby_tickets = input(del(2)+2:end);
ticket_numbers = zeros(height(nearby_tickets),height(rules));
correct_tickets = true(height(nearby_tickets),1);
allowed_numbers = [];
rule_numbers = cell(height(rules),1);
error_rate = 0;
res_part2 = 1;
for i=1:height(rules)
    numbers = str2double(extract(rules(i),digitsPattern));
    rule_numbers{i} = [numbers(1):numbers(2) numbers(3):numbers(4)];
    allowed_numbers = unique(cat(2,allowed_numbers,rule_numbers{i}));
end

for i=1:height(nearby_tickets)
    ticket_numbers(i,:) = str2double(extract(nearby_tickets(i),digitsPattern))';
    mem = ismember(ticket_numbers(i,:),allowed_numbers);
    if any(mem == 0)
        error_rate = error_rate + ticket_numbers(i,~mem);
        correct_tickets(i) = false;
    end
end
fprintf('Result part 1: %d\n',error_rate)
ticket_numbers = ticket_numbers(correct_tickets,:);
rt_bool = true(height(rules),height(rules));
for i=1:height(rule_numbers)    
    for j=1:height(rule_numbers)
        rt_bool(i,j) = all(ismember(ticket_numbers(:,j),rule_numbers{i}));
    end
end
srt = sum(rt_bool);
for i=1:height(rules)
    id = find(srt == i);
    rule = find(rt_bool(:,id));
    if rule <=6
        res_part2 = res_part2 * my_tickets(id);
    end
    rt_bool(rule,:) = 0;
end
fprintf('Result part 2: %d\n',res_part2)
toc