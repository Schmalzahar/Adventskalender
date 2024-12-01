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
side_size = 4;
cube_map = getCubeMap(map, side_size);
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
    switch 2
        case 1
            for n=1:num
                switch facing
                    case 0
                        c = rightdown(map(r,:),c);
                    case 1
                        r = rightdown(map(:,c)',r);
                    case 2
                        c = leftup(map(r,:),c);
                    case 3
                        r = leftup(map(:,c)',r);
                end
            end
        case 2
            for n=1:num
                switch facing
                    case 0
                        [r, c, facing, stop_flag] = rightdownP2(map, r, c, cube_map, facing, side_size);
                    case 1
                        % r = rightdown(map(:,c)',r, cube_map);
                        % [r, c, facing, stop_flag] = rightdownP2(map, r, c, cube_map, facing, side_size);
                    case 2
                        c = leftup(map(r,:),c, cube_map);
                    case 3
                        r = leftup(map(:,c)',r, cube_map);
                end
                if stop_flag
                    break
                end
            end
    end
    
    i = i + 1;
    if i > length(path)
        break
    end
    dir = path(i); 
    i = i + 1;   
end
toc

1000 * r + 4 * c + facing

function [rc] = rightdown(rowcol, rc, cube_map)
    if rc+1 > length(rowcol) || strcmp(rowcol(rc+1),' ')
        temp = rowcol~=' ';
        temp1 = rowcol(temp);
        if temp1(1) == '.'
            rc = find(temp,1);
        end
    elseif strcmp(rowcol(rc+1),'.')
        rc = rc + 1;
    end
end

function [r, c, facing, stop_flag] = rightdownP2(map, r, c, cube_map, facing, sz)
stop_flag = 0;
if facing == 0
    if c <= size(map,2) && strcmp(map(r,c+1), '.')
        c = c + 1;
        return
    elseif c <= size(map,2) && strcmp(map(r,c+1), '#')
        stop_flag = 1;
        return
    end
elseif facing == 3
    if r <= size(map,1) && strcmp(map(r+1,c), '.')
        r = r + 1;
        return
    elseif r <= size(map,1) && strcmp(map(r+1,c), '#')
        stop_flag = 1;
        return
    end
end
switch cube_map(r,c)
    case '1'
    case '2'
        omap = 1+sz:2*sz; nmap = 4*sz:-1:1+3*sz;
        nc = nmap(omap == r); nr = 1+2*sz;
        if strcmp(map(nr,nc), '.')
            facing = 1;
            c = nc; r = nr;
            return
        end
    case '3'
    case '4'
    case '5'
    case '6'

end
end


function [rc] = leftup(rowcol, rc, cube_map)
    if rc-1 == 0 || strcmp(rowcol(rc-1),' ')
        temp = rowcol~=' ';
        temp1 = rowcol(temp);
        if temp1(end) == '.'
            rc = find(temp,1,'last');
        end
    elseif strcmp(rowcol(rc-1),'.')
        rc = rc - 1;
    end
end

function cubeMap = getCubeMap(map,sz)
    cubeMap = char(double(map ~= ' ')+'0');
    % manually
    cubeMap(1+sz:2*sz,1+2*sz:3*sz) = '2';
    cubeMap(1+2*sz:3*sz,1+3*sz:4*sz) = '3';
    cubeMap(1+sz:2*sz,1:sz) = '4';
    cubeMap(1+sz:2*sz,1+sz:2*sz) = '5';
    cubeMap(1+2*sz:3*sz,1+2*sz:3*sz) = '6';

end