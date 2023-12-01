%% Day 3
% 06:00-06:15 part 1
% 06:15-06:25 part 2

a = readlines("a03.txt");
priority = 0;
for i=1:height(a)
    rucksack = char(a(i,1));
    compartment1 = rucksack(1:end/2);
    compartment2 = rucksack(end/2+1:end);
    % find commpn letters
    members = compartment1(ismember(compartment1, compartment2));
    letter = members(1);
    if letter-0>96
        priority = priority + letter - 96;
    else
        priority = priority + letter - 38;
    end
end
priority

%% part 2
priority = 0;
for i=1:3:height(a)
    group1 = char(a(i,1));
    group2 = char(a(i+1,1));
    group3 = char(a(i+2,1));
    badge = group1((ismember(group1,group3)==ismember(group1,group2)) & ismember(group1,group3)==ones(size(group1,1)));
    badge = badge(1);
    if badge-0>96
        priority = priority + badge - 96;
    else
        priority = priority + badge - 38;
    end
end
priority
