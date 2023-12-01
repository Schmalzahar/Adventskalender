tic
cups = 418976235;
cups = num2str(cups)-'0';
% moves = 100000000;
moves = 10000000;%00000
numbers = zeros(1,1000000);
for i=1:8
    numbers(cups(i)) = cups(i+1);
end
numbers(cups(end)) = 10;
for i=10:1000000-1
    numbers(i) = i+1;
end
numbers(end) = 4;
current = 4;
for i=1:moves
    value = current;
    next1 = numbers(current);
    next2 = numbers(next1);
    next3 = numbers(next2);
    while true
        value = value - 1;
        if value == 0
            value = 1000000;
        end
        if ~((next1 == value) || (next2 == value) || (next3 == value))
            break
        end
    end
    numbers(current) = numbers(next3);
    numbers(next3) = numbers(value);
    numbers(value) = next1;

    current = numbers(current);
end
res = numbers(1) * numbers(numbers(1));
sprintf("Result: %d",res)
toc