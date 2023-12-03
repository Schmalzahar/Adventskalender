input = char(readlines("a03.txt"));
chars = [];
parts = struct;
for i = 1:numel(input)
    if ~contains('01234566789.', input(i))
        chars(end + 1,1) = i;
    end
end
for r = 1:size(input,1)
    row = input(r,:);
    matches = regexp(row, '(\d+)', 'tokenExtents');
    for m = matches
        nexts = [];
        ma = m{:};
        for s=-1:1
            for d=-1:1
                for c = ma(1):ma(end)
                    if (r+s>0) && (r+s<=size(input,1))...
                            && (c+d>0) && (c+d<=size(input,2))
                        nexts(end + 1,:) = sub2ind(size(input),r+s,c+d);
                    end
                end
            end
        end      
        % Filter neighbors that are also in chars
        nexts = intersect(nexts, chars, 'rows');    
        if size(nexts,1)>0
            if isfield(parts, ['A',num2str(nexts)])
                parts.(['A',num2str(nexts)]) = [parts.(['A',num2str(nexts)]) str2double(row(ma(1):ma(end)))];
            else
                parts.(['A',num2str(nexts)]) = str2double(row(ma(1):ma(end)));
            end                
        end
    end
end
pv = fieldnames(parts);
res1 = 0;
res2 = 0;
for p = pv'
    res1 = res1 + sum(parts.(p{:}));
    if size(parts.(p{:}),2) == 2
        res2 = res2 + prod(parts.(p{:}));
    end
end