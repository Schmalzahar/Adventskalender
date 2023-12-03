input = char(readlines("a03.txt"));
chars = find(arrayfun(@(x) ~contains('01234566789.', x), input));
parts = dictionary;
for r = 1:size(input,1)
    row = input(r,:);
    matches = regexp(row, '(\d+)', 'tokenExtents');
    for m = matches
        ma = m{:};               
        rows = max(1, r - 1):min(size(input, 1), r + 1);
        cols = max(1, ma(1) - 1):min(size(input, 2), ma(2) + 1);
        [row_indices, col_indices] = meshgrid(rows, cols);        
        nexts = sub2ind(size(input),row_indices,col_indices);   
        nexts = intersect(reshape(nexts,[],1), chars, 'rows');    
        if size(nexts,1)>0
            if ~isConfigured(parts) || ~isKey(parts,nexts)
                parts(nexts) = {str2double(row(ma(1):ma(end)))};
            else
                parts(nexts) = {[parts{nexts}, str2double(row(ma(1):ma(end)))]};
            end           
        end
    end
end
res1 = sum([parts.values{:}],'all');
res2 = sum(arrayfun(@(x) (size(parts.values{x},2)==2)*prod(parts.values{x}), 1:parts.numEntries));