input = readmatrix("input_01.txt");
% Find the two entries that sum to 2020 and multiply them together
% make a map with the multiplications
[index,~] = find((input + input') == 2020);
result = prod(input(index))
% Part 2
[index2,~] = find(input + input' + reshape(input,[1,1,height(input)]) == 2020);
index2 = unique(index2);
result2 = prod(input(index2))
