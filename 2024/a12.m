input = char(readlines("a12.txt"));
kernel = [0 1 0; 1 0 1; 0 1 0];
ns = {[0 0 1],[1 0 0],[0;0;1],[1;0;0]};

plants = unique(input)';
price1 = 0;
price2 = 0;

for p=plants    
    regions = bwlabel(input == p, 4);
    for r=1:numel(unique(regions))-1 % 0 is ont a region
        region = regions == r;
        region = padarray(region, [1 1]);
        perim = imdilate(region, kernel) & ~region;
        regionArea = sum(region,'all');
        price1 = price1 + sum(conv2(region, kernel, 'same') .* perim,'all') * regionArea;

        sides = 0;
        for n = ns
            md = bwconncomp(conv2(region,n{:},'same') .* ~region,4);
            sides = sides + numel(md.PixelIdxList);
        end
        price2 = price2 + sides * regionArea;
    end
end
price1
price2