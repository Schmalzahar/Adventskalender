%% Day 22
% part 1: 12:16
ccc

input = readlines("a22.txt");
tic
split_line = find(input == '');
map = input(1:split_line-1);
map = char(map);
path = char(input(split_line+1));
temp = strfind(map(1,:),'.');
r = 1;
c = temp(1);
i = 1;
facing = 0;
dir = 'temp';
pos = [r c];
while true       
    if strcmp(dir,'R')
        facing = mod((facing + 1),4);
    elseif strcmp(dir,'L')
        facing = mod((facing - 1),4);
    end
    num = path(i);
    if i < length(path)
        while ~isnan(str2double(path(i+1)))
            num = strcat(num,path(i+1));
            i = i + 1;
            if i == length(path)
                break
            end
        end
    end
    num = str2double(num);
    % move num steps in direction
    switch facing
        case 0
            c = rightdown(map(r,:),c,num);
        case 1
            r = rightdown(map(:,c)',r,num);
        case 2
            c = leftup(map(r,:),c,num);
        case 3
            r = leftup(map(:,c)',r,num);
    end
    i = i + 1;
    if i > length(path)
        break
    end
    dir = path(i); 
    i = i + 1;   
    if length(pos) == 550
        test = 1;
    end
end
toc
1000 * r + 4 * c + facing
function [rc] = rightdown(rowcol, rc, num)
    for i=1:num
        if rc+1 > length(rowcol) || strcmp(rowcol(rc+1),' ')
            temp = strfind(rowcol,'.');
            temp1 = strfind(rowcol,'#');
            if isempty(temp1) || min(temp) < min(temp1)
                rc = temp(1);
            else
                break
            end
        elseif strcmp(rowcol(rc+1),'.')
            rc = rc + 1;
        else
            break
        end
    end
end
function [rc] = leftup(rowcol, rc, num)
    for i=1:num
        if rc-1 == 0 || strcmp(rowcol(rc-1),' ')
            temp = strfind(rowcol,'.');
            temp1 = strfind(rowcol,'#');
            if isempty(temp1) || max(temp) > max(temp1)
                rc = temp(end);
            else
                break
            end
        elseif strcmp(rowcol(rc-1),'.')
            rc = rc - 1;
        else
            break
        end
    end
end

function line = getLine(map,rowcol,rc)
   sz = 4;
   if rowcol == 'row'
   elseif rowcol == 'col'
   end
end