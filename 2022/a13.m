%% Day 13
% part 1: 11:13-16:06
% part 2: 16:06-17:09

a = readlines("a13.txt");
%% part 1
i = 1;
k = 1;
right_order = 0;
while true
    line1 = char(a(i));
    line2 = char(a(i+1));
    flag = compareValues(line1,line2);    
    i = i+3;
    if flag == 1
        right_order = right_order + k;
    end
    if i>length(a)
        break
    end
    k = k+1;
end
right_order
%% part 2 bubble
a = readlines("a13.txt");
tic
a = a(~arrayfun(@(x) isempty(char(x)),a));
a(end+1) = '[[2]]';
a(end+1) = '[[6]]';
l = length(a);
n = 1;
while true
    swapped = false;
    %for i=1:n-1
    for i=l:-1:1+n
        
        %a(i)
        %a(i+1)
        if compareValues(char(a(i-1)),char(a(i))) == 0
            temp = a(i-1);
            a(i-1) = a(i);
            a(i) = temp;
            swapped = true;
        end
    end
    n = n+1;
    if swapped == false
        break
    end
end
toc
find(a == '[[2]]') * find(a == '[[6]]')
%% part 2 insertion
a = readlines("a13.txt");
tic
a = a(~arrayfun(@(x) isempty(char(x)),a));
a(end+1) = '[[2]]';
a(end+1) = '[[6]]';
% bubblesort
len = length(a);
for i=2:len
    d = i;
    pivot = a(d);
    while((d > 1) && compareValues(char(a(d-1)),char(pivot)) == 0)
        a(d) = a(d-1);
        d = d-1;
    end
    a(d) = pivot;
end

toc
find(a == '[[2]]') * find(a == '[[6]]')
%%

function flag = compareValues(line1,line2)
    % flag = 0: false,
    % flag = 1: true,
    % flag = 2: otherwise, continue
    while true
        if isempty(line1)
            if isempty(line2)
                flag = 2;
                break
            else
                flag = 1;
                break
            end
        elseif isempty(line2)
            flag = 0;
            break
        end
        if ~isnan(str2double(line1(1))) && ~isnan(str2double(line2(1)))
            % compare first number
            num1_idx = regexp(line1,'(\d+)','tokenExtents','once');
            num2_idx = regexp(line2,'(\d+)','tokenExtents','once');
            if str2double(line1(num1_idx(1):num1_idx(end))) > str2double(line2(num2_idx(1):num2_idx(end)))
                %wrong order
                flag = 0;
                break
            elseif str2double(line1(num1_idx(1):num1_idx(end))) < str2double(line2(num2_idx(1):num2_idx(end)))
                %right order
                flag = 1;
                break
            end
            line1 = line1(num1_idx(end)+2:end);
            line2 = line2(num2_idx(end)+2:end);
        elseif ~isnan(str2double(line1(1))) && isnan(str2double(line2(1)))
            % first value, second bracket
            % convert first to bracket
            num1_idx = regexp(line1,'(\d+)','tokenExtents','once');
            line1 = strcat(line1(1:num1_idx(1)-1),'[',line1(num1_idx(1):num1_idx(end)),']',line1(num1_idx(end)+1:end));
        elseif isnan(str2double(line1(1))) && ~isnan(str2double(line2(1)))
            % first bracket, second value
            % convert second to bracket
            num2_idx = regexp(line2,'(\d+)','tokenExtents','once');
            line2 = strcat(line2(1:num2_idx(1)-1),'[',line2(num2_idx(1):num2_idx(end)),']',line2(num2_idx(end)+1:end));
        else
            [first1, remainder1] = splitFirstBracket(line1);
            [first2, remainder2] = splitFirstBracket(line2);
            % remove brackets from first
            first1 = first1(2:end-1);
            first2 = first2(2:end-1);
            flag = compareValues(first1,first2);
            if flag == 2
                flag = compareValues(remainder1,remainder2);
                if flag == 2
                    break
                end
            end
            if flag == 1 || flag == 0
                break
            end                           
        end
    end
end

function [first, remainder] = splitFirstBracket(line)
    depth = 0;
    for i=1:length(line)
        if line(i) == '['
            depth = depth + 1;
        elseif line(i) == ']'
            depth = depth - 1;
        elseif ~isnan(str2double(line(i))) || line(i) == ','
            continue
        end
        if depth == 0
            first = line(1:i);
            remainder = line(i+2:end);
            return
        end
    end
end