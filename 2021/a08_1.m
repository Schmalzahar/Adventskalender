%% Day 8, version 2
% Digits 1,4,7 and 8 need 2, 4, 3 and 7 segments
%segments = readcell("input_a08.txt");
segments = readmatrix("input_a08.txt","OutputType","string");
output_values = segments(:,12:15);
% count the number of times the strings are 2,3,4 or 7 long
output_length = cellfun(@length,output_values);
output_length_occurences = histcounts(output_length,6); % 6 because there are 6 options (2-7)
result = sum(output_length_occurences(1:3))+output_length_occurences(6);
disp("The result is: "+result)
%% 8.2
signal_values = segments(:,1:10);
numbers = 0;
for i = 1:size(signal_values,1)
    signal = signal_values(i,:);
    % count the number of each letter
    nums = zeros(7,10);
    let = {'a' 'b' 'c' 'd' 'e' 'f' 'g'};
    decode = zeros(7);
    for j=1:7
        nums(j,:) = contains(signal,let{j});
    end
    % The one that occurs 4 times maps to e
    decode(sum(nums,2)==4,5) = 1;
    % The one that occurs 9 times maps to f
    decode(sum(nums,2)==9,6) = 1;
    % The one that occurs 6 times maps to b
    decode(sum(nums,2)==6,2) = 1;
    % The number with 2 digits determines what maps to c
    decode(xor(logical(nums(:,sum(nums,1)==2)),sum(nums,2)==9),3) = 1;
    % The number with 3 digits determines what maps to a
    decode(xor(logical(nums(:,sum(nums,1)==2)),logical(nums(:,sum(nums,1)==3))),1) = 1;
    % The number with 4 digits determines what maps to d
    decode(nums(:,sum(nums,1)==4) & sum(nums,2)==7,4) = 1;
    % Last one
    decode(~sum(decode,2),~sum(decode)) = 1;
    % Read the output
    number = zeros(size(output_values,2),1);
    for j=1:size(output_values(i,:),2)
        output = char(output_values(i,j));
        res = false(7,1);
        for k=1:length(output)
            op = output(k);
            res = res | ismember(let, op)';
        end
        res_tr = decode' * double(res);
        number(j) = getNumber(res_tr);
    end
    numbers = numbers + str2double(erase(num2str(number'),' '));
end

function number =  getNumber(in)
    len = sum(in);
    switch len
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
    if len == 5
        % either 2, 3 or 5
        if in(2)
            number = 5;
        elseif in(5)
            number = 2;
        else
            number = 3;
        end
    else
        % either 0, 6 or 9
        if ~in(4)
            number = 0;
        elseif in(3)
            number = 9;
        else
            number = 6;
        end
    end
end