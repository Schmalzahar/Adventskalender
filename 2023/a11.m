galaxies = char(readlines('a11.txt')) == '#';
[r,c] = find(galaxies);
cs = cumsum(ones(1,size(galaxies,1)) + ~any(galaxies)*(10^6-1));
rs = cumsum(ones(size(galaxies,2),1) + ~any(galaxies,2)*(10^6-1));
(sum(abs(cs(c)-cs(c)') + abs(rs(r)-rs(r)'),"all"))/2