%% Day 4.1
data = readcell("input_a04.txt");
order = str2double(strsplit(data{1,1},","));
boards = cell2mat(data(2:end,:));
boardWinner = 0;
width = 5;
unmarked = 0;
for num=order
    % make all occurances of num in the boards to NaN
    boards(boards==num) = NaN;
    % Check for a winner
    for boardNum=1:(size(boards,1)/width)
        % Win condition 1: complete column is NaN. Go through each column
        % of each board
        for col=1:width
            if all(isnan(boards((1+(boardNum-1)*width):(5+(boardNum-1)*width),col)))
                boardWinner = boardNum;
            end
        end
        % Win condition 2: complete row is NaN. Go through each row
        % of each board
        for row=1:width
            if all(isnan(boards((boardNum-1)*width+row,:)))
                boardWinner = boardNum;                
            end
        end
    end
    if boardWinner ~= 0
        winnerBoard = boards((boardWinner-1)*width+1:(boardWinner-1)*width+width,:);
        unmarked = sum(sum(winnerBoard,'omitnan'),'omitnan');
        break
    end
end
result = num*unmarked;
disp("Result: "+result)
%% 4.2: which board wins last? 
order = str2double(strsplit(data{1,1},","));
boards = cell2mat(data(2:end,:));
boardWinner = 0;
width = 5;
unmarked = 0;
noOfBoards = size(boards,1)/width;
for num=order
    % make all occurances of num in the boards to NaN
    boards(boards==num) = NaN;
    % Check for a winner
    for boardNum=1:(size(boards,1)/width)
        % dont go through boards that have already won
        if any(boardNum==boardWinner)
            continue
        end
        % Win condition 1: complete column is NaN. Go through each column
        % of each board
        for col=1:width
            if all(isnan(boards((1+(boardNum-1)*width):(5+(boardNum-1)*width),col)))
                boardWinner(end+1) = boardNum;
            end
        end
        if any(boardNum==boardWinner)
            continue
        end
        % Win condition 2: complete row is NaN. Go through each row
        % of each board
        for row=1:width
            if all(isnan(boards((boardNum-1)*width+row,:)))
                boardWinner(end+1) = boardNum;                
            end
        end
    end

    
    if size(boardWinner,2) == noOfBoards+1 % no board left
        loser_board = boardWinner(end);
        loser_Board = boards((loser_board-1)*width+1:(loser_board-1)*width+width,:);
        unmarked = sum(sum(loser_Board,'omitnan'),'omitnan');
        break
    end

end
result2 = num*unmarked;
disp("Result: "+result2)