input = readlines("input_14.txt");
tic
mem = struct;
for i=1:height(input)
    line = input(i);
    if contains(line,'mask')
        mask = char(extractAfter(input(i),'= '));
    else
        lin = dec2bin(str2double(extractAfter(line,'= ')));
        lin = append(repelem('0',36-length(lin)),lin);
        new_line = mask;
        new_line(new_line == 'X') = lin(new_line == 'X');
        mem.(append('a',extractBetween(line,'[',']'))) = bin2dec(new_line);
    end
end
z = struct2cell(mem(:));
fprintf('Result part 1: %d\n',sum([z{:}]))
toc
%% Part 2
tic
mem = struct;
for i=1:height(input)
    line = input(i);
    if contains(line,'mask')
        mask =input(i);
        mask = char(extractAfter(mask,'= '));
    else
        lin = dec2bin(str2double(extractBetween(line,'[',']')));
        lin = append(repelem('0',36-length(lin)),lin);
        post_mask = mask;
        post_mask(post_mask == '0') = lin(post_mask == '0');
        multi_line_after_mask = strrep(strcat("a",num2str(bin2dec(floating(post_mask, count(post_mask,'X'))))),' ','');
        num = str2double(extractAfter(line,'= '));
        for j=1:height(multi_line_after_mask)
            mem.(multi_line_after_mask(j,:)) = num;
        end
    end
end  
z = struct2cell(mem);
fprintf('Result part 2: %d\n',sum([z{:}]))
toc

function line = floating(line,n)
    if n==0
        return
    end
    out1 = line;
    out2 = line;
    id = find(line(1,:) == 'X',1);
    out1(:,id) = '1';
    out2(:,id) = '0';
    line = floating(cat(1,out1,out2),n-1);
end