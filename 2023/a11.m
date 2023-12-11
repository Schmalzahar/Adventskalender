input = char(readlines('a11.txt'));
galaxies = input == '#';
expand_col = find(sum(galaxies) == 0);
expand_row = find(sum(galaxies,2) == 0);
for r = flip(expand_row)'
    input = [input(1:r,:); repelem('.',size(input,2)); input(r+1:end,:)];
end
for c = flip(expand_col)
    input = [input(:,1:c) repelem('.',size(input,1))' input(:,c+1:end)];
end
galaxies = find(input == '#');
pairs = nchoosek(galaxies,2);
paths = zeros(size(pairs,1),1);
for i=1:height(paths)
    [rs, cs] = ind2sub(size(input), pairs(i,:));
    paths(i) = abs(cs(1)-cs(2))+abs(rs(1)-rs(2));
end
sum(paths)