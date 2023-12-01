%% Day 18
input = fileread("input_a18.txt");
lines = erase(string(strsplit(input,'\r'))',char(10)); %#ok<CHARTEN> 
tic
while true
    str = red(add(lines(1),lines(2)));
    if length(lines) > 2
        lines = [str;lines(3:end)];
    else
        break
    end    
end
out = checkMag(str)
toc
%% Part 2
% 2*(10 over 2) combinations
% combi1 = nchoosek(1:height(lines),2);
% combi2 = combi1(:,2:-1:1);
% combi = cat(1,combi1, combi2);
% ls = 0;
% for i=1:height(combi)
%     line1 = lines(combi(i,1));
%     line2 = lines(combi(i,2));
%     str = red(add(line1,line2));
%     mag = checkMag(str);
%     if mag > ls
%         ls = mag;
%     end
% end
% ls

function out = checkMag(str)
    % magnitude of a pair is 3 times the magnitude of its left element plus
    % 2 times the magnitude of its right element
    nmax = 3;
    str = char(str);
    while true
        strs = checkMult(str);
        for n=1:nmax 
            for i=1:width(strs)
                strs_i = getN(strs(:,i));
                if i==1
                    new_strs = strs_i;
                else
                    new_strs = cat(2,new_strs,strs_i);
                end
            end
            strs = new_strs;
        end   
        % get first pair
        id = gmid(strs);
        if isempty(id) || all(id == 0)
            nmax = nmax-1;
            if nmax == 0
                % final calculation
                nums = extract(str,digitsPattern);
                num1 = str2double(nums{1});
                num2 = str2double(nums{2});
                out = 3 * num1 + 2 * num2;
                return
            end
            continue
        end
        % replace id with the formula
        nums = extract(str(id),digitsPattern);
        num1 = str2double(nums{1});
        num2 = str2double(nums{2});
        res = 3 * num1 + 2 * num2;
        strleft = str(1:id(1)-1);
        strright = str(id(end)+1:end);
        str = append(strleft,num2str(res),strright);
    end
end

function str = red(str)
    %reduce
    while true
        nstr = exp(str);
        if strcmp(nstr,str)
            nnstr = spl(nstr);
        else
            nnstr = nstr;
        end
        if strcmp(str,nnstr)
            break
        else
            str = nnstr;
        end
    end
end

function str = spl(str)
    % split
    digits = cellfun(@(x) str2double(x)>9,extract(str,digitsPattern));
    if ~any(digits)
        return
    else
        % left most
        ind = find(digits,1);
        nums = regexp(str,'\d');
        id = nums(ind);
        while true
            if any(id+1==nums)
                ids = [id,id+1];
                break
            else
                break
            end
        end
        num = str2double(str(ids));
        % split the number
        left = floor(num/2);
        right = ceil(num/2);
        strleft = str(1:ids(1)-1);
        strright = str(ids(end)+1:end);
        new_pair = append('[',num2str(left),',',num2str(right),']');
        str = append(strleft,new_pair,strright);
    end
end

function str = exp(str)
    str = char(str);
    % explode
    id = fl4(str); % [num,num]
    if id == 0
        str;
        return
    end
    nums = extract(str(id),digitsPattern);
    num1 = str2double(nums{1});
    num2 = str2double(nums{2});
    % pairs left value is added to the first regular number to the left
    strleft = str(1:id(1)-1);
    leftnumid_start = length(strleft) + 1 - regexp(rv(strleft),'\d{1,3}','end','once');
    leftnumid_end = length(strleft) + 1 - regexp(rv(strleft),'\d{1,3}','start','once');
    if ~isempty(leftnumid_start)
        t0 = regexp(strleft,'\d{1,3}','match');
        new_number = str2double(t0{end})+num1;
        t1 = extractBefore(strleft,leftnumid_start);
        t2 = extractAfter(strleft,leftnumid_end);
        strleft = append(t1,num2str(new_number),t2);
    end
    strright = str(id(end)+1:end);
    rightnumid_start = regexp(strright,'\d{1,3}','start','once');
    rightnumid_end = regexp(strright,'\d{1,3}','end','once'); % if 0-9, same
    if ~isempty(rightnumid_start)
        new_number = str2double(regexp(strright,'\d{1,3}','match','once'))+num2;
        t1 = extractBefore(strright,rightnumid_start);
        t2 = extractAfter(strright,rightnumid_end);
        strright = append(t1,num2str(new_number),t2);
    end
    % entire exploding pair is replaced with 0
    str = append(strleft,'0',strright);
end

function id = fl4(str)
    % returns the indices of the leftmost pair which is nested inside four
    % pairs. Indices include the []
    strs = checkMult(char(str));
    for n=1:4
        for i=1:width(strs)
            strs_i = getN(strs(:,i));
            % cut off after found the first
            if height(strs_i) == 5 && strs_i(5) ~= ""
                id = gmid(strs_i);
                return
            end
            if i==1
                new_strs = strs_i;
            else
                new_strs = cat(2,new_strs,strs_i);
            end
        end
        strs = new_strs;
    end
    id = gmid(strs);
end

function out = getN(ar)
    le = ar(end); % last entry
    if le ~= ""
        new_pairs = checkMult(rmp(le));
        out = cat(1,repmat(ar,1,width(new_pairs)),new_pairs);
    else
        out = cat(1,ar,"");
    end
end

function t2 = rmp(str)
    ch = char(str);
    % remove the outermost pair
    t1 = extractAfter(ch,'[');
    t2 = rv(extractAfter(rv(t1),']'));
    if t2(end)~=']'
        t2 = rv(extractAfter(rv(t2),','));
    end
    if t2(1)~='['
        t2 = extractAfter(t2,',');
    end    
end

function pairs = checkMult(ch)
    pairs = string.empty;
    for j=1:size(ch,3)
        jch = erase(ch(:,:,j),' ');
        cn = 0;    
        lasti = 1;
        i=1;
        while i<length(jch)
            % count up the left most '[' and count back if ']'
            if jch(i) == '['
                cn = cn + 1;
            elseif jch(i) == ']'
                cn = cn - 1;
            end
            if i>0 && i~=length(jch) && cn == 0
                pairs(end+1,:) = jch(lasti:i);
                % now, a comma follows, so skip an index
                i = i+2;
                lasti = i;
            else
                i = i+1;
            end
        end
        if isempty(pairs)
            pairs = string(jch);
        else
            pairs(end+1,:) = jch(lasti:end);
        end
    end
    pairs = pairs';
end

function out = rv(ch)
    out = ch(end:-1:1);
end

function id = gmid(strs)
    % possibility for multiple pairs. height(strs) is max5
    % multiple pairs that are nested inside four pairs
    if width(strs) > 1
        % take the first pair
        i=1;
        while i<=width(strs)
            if strs(end,i) == ""
                i = i+1;
            else
                break
            end
        end
        if i>width(strs) % no pair 4 deep
            id = 0;
            return
        end
        strs = strs(:,i);
    end
    previd = 1:length(char(strs(1,:)));
    for i=1:height(strs)-1
        id = gid(strs(1,:),strs(i+1,:)); % final id must be in this range
        previd = previd(ismember(previd, id));        
    end
    id = previd(1:length(char(strs(end,:)))); % take the first pair that fits
end

function id = gid(a,b)
    id = strfind(replace(a,b,repmat(' ',1,length(char(b)))),' ');
end

function str = add(a,b)
    str = append('[',a,',',b,']');
end