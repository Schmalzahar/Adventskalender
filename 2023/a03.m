input = char(readlines("a03.txt"))'-'0';
gears = find(input == -6);
res = 0;
number = [];
symclose = [];
gearclose = [];
gearsum = 0;
for i=1:numel(input)
    m = input(i);
    if 0<=m && m<=9
        number = [number m];
        symclose = [symclose symbolNeighbor(input,i)];
    elseif any(symclose)
        res = res + sum(number .* 10.^(numel(number)-1:-1:0));
        number = [];
        symclose = [];
    else
        number = [];
        symclose = [];
    end

end
res
%%
gearres = 0;
for g = gears'
    gearres = gearres + numClose(input, g)
end


%%
function res = numClose(matrix, index)
% Get the size of the matrix
    [rows, cols] = size(matrix);

    % Convert linear index to subscripts
    [subRow, subCol] = ind2sub([rows, cols], index);

    % Define the range of neighbors for each dimension
    rowRange = max(1, subRow - 1):min(rows, subRow + 1);
    colRange = max(1, subCol - 1):min(cols, subCol + 1);

    % Extract the submatrix using neighboring subscripts
    submatrix = matrix(rowRange, colRange);
    
    num = [];
    nums = [];
    % Possible numbers have to be at least 2
    possibleNums = 0<=submatrix & submatrix<=9;
    if sum(possibleNums,'all')>1
        % find complete numbers. Starting top left.
        for col = colRange
            for row = rowRange
                matrix(row,col)
                if numCon(row,col,matrix)
                    % number, check left of number
                    if numCon(row-1,col,matrix)
                        if numCon(row-2,col,matrix)
                            num = matrix(row-2,col);
                        end
                        num = [num matrix(row-1,col)];
                    end
                    num = [num matrix(row,col)];
                    if numCon(row+1,col,matrix)
                        num = [num matrix(row+1,col)];
                        if numCon(row+2,col,matrix)
                            num = [num matrix(row+2,col)];
                        end
                    end
                    nums = [nums sum(num .* 10.^(numel(num)-1:-1:0))];
                    num = [];
                end
            end
        end
    end
    if length(unique(nums)) == 2
        res = prod(unique(nums));
    else
        res = 0;
    end
    
end

function out = numCon(row,col,matrix)
    out = (0<=matrix(row,col) && matrix(row,col)<=9);
end

function res = symbolNeighbor(matrix, index)
    % Get the size of the matrix
    [rows, cols] = size(matrix);

    % Convert linear index to subscripts
    [subRow, subCol] = ind2sub([rows, cols], index);

    % Define the range of neighbors for each dimension
    rowRange = max(1, subRow - 1):min(rows, subRow + 1);
    colRange = max(1, subCol - 1):min(cols, subCol + 1);

    % Extract the submatrix using neighboring subscripts
    submatrix = matrix(rowRange, colRange);
    
    res = any((-2>submatrix) | submatrix>9 | submatrix == -1,'all');
end