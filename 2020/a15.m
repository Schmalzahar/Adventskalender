input = readmatrix("input_15.txt");
N = 30000000;
numbers = zeros(2,N);
for n=1:length(input)
    numbers(2,input(n)+1) = n;
end
tic
recent_number = input(end);
for i=length(input)+1:N
    if numbers(1,recent_number+1) == 0
        recent_number = 0;
    else
        recent_number = diff(numbers(:,recent_number+1));
    end        
    numbers(1,recent_number+1) = numbers(2,recent_number+1);
    numbers(2,recent_number+1) = i;
end
recent_number
toc