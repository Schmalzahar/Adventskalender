%% Day 6.1 and 6.2
ages = readmatrix("input_a06.txt");
days_to_model = 500;
num_fish = zeros(days_to_model,1);
% there are only 9 different possibilities of ages (0-9). Save the number
% of occurences of the ages in a 1x9 array.
for i=0:8
    age_occurences(i+1) = sum(ages==i);
end
for day=1:days_to_model    
    reduced = cat(2,age_occurences(2:end),age_occurences(1)); % Move the array one to the left
    % For each fish that was age 0 (age_occurences(1), add a new one at age
    % 6
    reduced(7) = reduced(7) + age_occurences(1);
    age_occurences = reduced;
    num_fish(day)=sum(age_occurences);
end
disp("Number of fish after "+days_to_model+" days: "+sum(age_occurences))
semilogy(1:days_to_model,num_fish)