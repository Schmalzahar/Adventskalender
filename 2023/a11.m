galaxies = char(readlines('a11.txt')) == '#';
expand_col = find(sum(galaxies) == 0);
expand_row = find(sum(galaxies,2) == 0);
expansion = 10^6-1; % part 1: 1, part 2: 10^6-1
pairs = nchoosek(find(galaxies),2);
[rs, cs] = ind2sub(size(galaxies), pairs);
rs = sort(rs,2); cs = sort(cs,2);
res = sum(abs(rs(:,1)-rs(:,2))+abs(cs(:,1)-cs(:,2)));
for i=1:height(pairs)
    row_dist = sum(rs(i,1)<expand_row & expand_row < rs(i,2));
    col_dist = sum(cs(i,1)<expand_col & expand_col < cs(i,2));
    res = res + (row_dist + col_dist) * expansion;
end
res