map = char(readlines("a04.txt"));
sz = size(map);
xmas_counter = 0;
x_mas_counter = 0;
for n=1:4
    [xx, xy] = find(map == 'X');
    for i=1:numel(xx)        
        try % right
            if strcmp(map(xx(i),xy(i):(xy(i)+3)), 'XMAS')
                xmas_counter = xmas_counter + 1;
            end        
        end        
        xxx = (1:4)' + xx(i) - 1;
        yyy = (1:4)' + xy(i) - 1;
        try % diagonal down right
            if strcmp(map(sub2ind(sz,xxx,yyy))', 'XMAS')
                xmas_counter = xmas_counter + 1;
            end       
        end
    end
    % part 2
    [ax, ay] = find(map == 'A');
    for a=1:numel(ax)
        ae = [-1 0 1];
        axx = ax(a) + ae; axx(axx<1) = []; axx(axx>sz(1)) = []; 
        ayy = ay(a) + ae; ayy(ayy<1) = []; ayy(ayy>sz(2)) = [];
        if size(axx,2) == 3 && size(ayy,2) == 3
            if strcmp(map(sub2ind(sz,axx,ayy)), 'MAS') && ...
                    strcmp(map(sub2ind(sz,fliplr(axx),ayy)), 'MAS')
                x_mas_counter = x_mas_counter + 1;
            end
        end
    end
    map = rot90(map);
end
xmas_counter
x_mas_counter