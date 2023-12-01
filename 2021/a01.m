%% Day 1.1
data = readmatrix("input_a01.txt");
result = sum(data(2:end)>data(1:end-1))
%% Day 1.2 with sliding window
% a+b+c<b+c+d is just a<d
result2 = sum(data(4:end)>data(1:end-3))