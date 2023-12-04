input = char(readlines("a02.txt"));
twos = 0;
threes = 0;
for i=1:length(input)
    line = input(i,:);
    [a,b] = mode(line);
    if b == 3
        threes = threes + 1; 
        while b == 3
            line = line(line~=a);
            [a,b] = mode(line);
        end
    end
    if b == 2
        twos = twos + 1;
    end
end
twos * threes
[n, m] = size(input);
% Create a matrix of absolute differences between all pairs of rows
diff_matrix = reshape(input, [n, 1, m]) ~= reshape(input, [1, n, m]);

% Find the pairs with exactly one differing digit
[row_idx, col_idx] = find(sum(diff_matrix, 3) == 1, 1);

char(input(row_idx,input(row_idx,:)-input(col_idx,:)==0)+97)