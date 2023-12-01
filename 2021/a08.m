%% Day 8.1
% Digits 1,4,7 and 8 need 2, 4, 3 and 7 segments
segments = readcell("input_a08.txt");
output_values = segments(:,12:15);
% count the number of times the strings are 2,3,4 or 7 long
output_length = cellfun(@length,output_values);
output_length_occurences = histcounts(output_length,6); % 6 because there are 6 options (2-7)
result = sum(output_length_occurences(1:3))+output_length_occurences(6);
disp("The result is: "+result)
%% 8.2
signal_values = segments(:,1:10);
signal_length = cellfun(@length,signal_values);
% 2 must be 1 and 3 must be 7, thus the digit not occuring in 1 must be a
digits = cell(size(signal_length,1),6);

two_digits = cf(signal_values, 2);
three_digits = cf(signal_values, 3);
four_digits = cf(signal_values, 4);
five_digits = cf(signal_values, 5);

% a
digits(:,1) = erase_digits(two_digits,three_digits); % map to a
% b,d,g
% There are three numbers with length 5 (2,3,5). Three contains (c,f),
% which also occurs in the number 1 (number with length 2)
% Find the number that contains (c,f)
% After erasing 5-2, the correct length will be three
three_1 = cellfun(@length,erase_digits(two_digits,five_digits(:,1))) == 3;
three_2 = cellfun(@length,erase_digits(two_digits,five_digits(:,2))) == 3;
three_3 = cellfun(@length,erase_digits(two_digits,five_digits(:,3))) == 3;
number_three_index = [three_1, three_2, three_3];
number_three = cellLog(five_digits,number_three_index);
% Erase (c,f)
number_three_1 = erase_digits(two_digits,number_three);
% Erase a
number_three_2 = erase_digits(digits(:,1),number_three_1); % this maps to (d,g)
% Number 4: four_digits
number_four_1 = erase_digits(two_digits,four_digits);
% The common between number_three_2 and number_four_1 maps to g
digits(:,7) = com(number_three_2, number_four_1);
% Number three without g is d
digits(:,4) = erase_digits(digits(:,7),number_three_2);
% Number four without d is b
digits(:,2) = erase_digits(digits(:,4),number_four_1);
% Number 5
% one of the three 5 digit numbers is 5. It is the one with the map to b.
% After erasing b, the correct length will be 4
five_1 = cellfun(@length,erase_digits(digits(:,2),five_digits(:,1))) == 4;
five_2 = cellfun(@length,erase_digits(digits(:,2),five_digits(:,2))) == 4;
five_3 = cellfun(@length,erase_digits(digits(:,2),five_digits(:,3))) == 4;
number_five_index = [five_1, five_2, five_3];
number_five = cellLog(five_digits,number_five_index);
digits(:,6) = eraseKnown(number_five, digits);
% c
digits(:,3) = eraseKnown(two_digits,digits);
% e: use number 2
number_two_index = not(number_five_index | number_three_index);
number_two = cellLog(five_digits,number_two_index);
digits(:,5) = eraseKnown(number_two,digits);
% Map complete
% Get result
result = getAllNumbers(output_values, digits)



function rest = erase_digits(short,long)
    short_split = regexp(short,'.','match');
    rest = cellfun(@erase,long,short_split,'UniformOutput',false);    
end

function out = cf(cell_in,num)
    cell_length = cellfun(@length,cell_in);
    out = cellLog(cell_in,cell_length == num);
end

function out = cellLog(cell_in,log_in)
    out = cell(size(log_in,1),sum(log_in(1,:),2));
    for j=1:size(cell_in,1)
        out(j,:) = cell_in(j,log_in(j,:));
    end
end

% Returns the common digit
function out = com(cell1, cell2)
    cell1split = regexp(cell1,'.','match');
    cell2split = regexp(cell2,'.','match');
    erased = cellfun(@erase,cell1split,cell2split,'UniformOutput',false);
    erased_hor = horzcat(erased{:});
    out = cellstr(reshape([erased_hor{:}],[size(cell1,1),1]));
end

function out = eraseKnown(cellin, digits)
    for i=1:size(digits,2)
        cellin = erase_digits(digits(:,i),cellin);
    end
    out=cellin;
end

function result = getAllNumbers(numstrs, digits)
    result = 0;
    for i=1:size(digits,1)
        result = result + getNumbers(numstrs(i,:),digits(i,:));
    end
end

function numbers = getNumbers(numstrs, digits)
    numbers = '';
    for i=1:length(numstrs)
        numbers(i) = num2str(getNumber(numstrs{1,i},digits));
    end
    numbers = str2double(numbers);
end

function number = getNumber(numstr, digits)
    numlen = length(numstr);
    switch numlen
        case 2
            number = 1;
            return
        case 3
            number = 7;
            return
        case 4
            number = 4;
            return
        case 7
            number = 8;
            return
        otherwise
    end
    if numlen == 5
        % either 2, 3 or 5
        % the one with a map to e must be 2. The one with map to b must be
        % 5
        if contains(numstr,digits{5})
            number = 2;
        elseif contains(numstr,digits{2}) 
            number = 5;
        else
            number = 3;
        end
    else
        % either 0, 6 or 9
        % if does not contain map to d, its zero
        if ~contains(numstr,digits{4})
            number = 0;
        elseif contains(numstr,digits{3})
            number = 9;
        else
            number = 6;
        end
    end
end
