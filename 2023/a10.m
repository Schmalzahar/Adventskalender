input = char(readlines('a10.txt'));
sz = size(input,1);

start = input == 'S';
vertp = input == '|';
horip = input == '-';
bnd_ne = input == 'L';
bnd_nw = input == 'J';
bnd_sw = input == '7';
bnd_se = input == 'F';
[loc_r, loc_c] = find(input == 'S');
dir = 's';
done = false;
loop = [loc_r, loc_c];
while ~done
    % south
    if dir == 's'
        loc_r = loc_r + 1;
        if vertp(loc_r, loc_c) == 1
            dir = 's';
        elseif bnd_ne(loc_r, loc_c) == 1
            dir = 'e';
        elseif bnd_nw(loc_r, loc_c) == 1
            dir = 'w';
        else
            done = true;
        end
    elseif dir == 'e'
        loc_c = loc_c + 1;
        if horip(loc_r, loc_c) == 1
            dir = 'e';
        elseif bnd_nw(loc_r, loc_c) == 1
            dir = 'n';
        elseif bnd_sw(loc_r, loc_c) == 1
            dir = 's';
        else
            done = true;
        end
    elseif dir == 'n'
        loc_r = loc_r - 1;
        if vertp(loc_r, loc_c) == 1
            dir = 'n';
        elseif bnd_se(loc_r, loc_c) == 1
            dir = 'e';
        elseif bnd_sw(loc_r, loc_c) == 1
            dir = 'w';
        else
            done = true;
        end   
    elseif dir == 'w'
        loc_c = loc_c - 1;
        if horip(loc_r, loc_c) == 1
            dir = 'w';
        elseif bnd_ne(loc_r, loc_c) == 1
            dir = 'n';
        elseif bnd_se(loc_r, loc_c) == 1
            dir = 's';
        else
            done = true;
        end
    end
    loop(end+1,:) = [loc_r, loc_c];
end
% part 1
(size(loop,1)-1)/2
% part 2
[rows,cols] = ind2sub(sz,1:numel(input));
[in,on] = inpolygon(rows,cols,loop(:,1),loop(:,2));
sum(in)-sum(on)
% vis
figure
plot(loop(:,1),loop(:,2))
hold on
plot(rows(in),cols(in),'b.')
plot(rows(in~=on),cols(in~=on),'r.')
plot(rows(~in),cols(~in),'k.')