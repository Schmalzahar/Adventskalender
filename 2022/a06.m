%% Day 6
% Part 1: 11:15-11:25
% Part 2: 11:25-11:26
tic
a = char(readlines("a06.txt"));
last_four = '';
%number_of_distinct_chars = 4;
number_of_distint_chars = 14;
for i=1:length(a)
    if length(last_four) < number_of_distint_chars
        last_four = append(last_four, a(i));
    else
        last_four = append(last_four(2:end),a(i));
    end
    % Check for four different chars
    if (length(unique(last_four)) == length(last_four) && length(last_four) == number_of_distint_chars)
        disp(i)
        break
    end    
end
toc