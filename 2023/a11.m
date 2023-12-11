galaxies = char(readlines('a11.txt')) == '#';
[r,c] = find(galaxies);
cs = cumsum(ones(1,size(galaxies,1)) + ~any(galaxies)*(10^6-1));
rs = cumsum(ones(size(galaxies,2),1) + ~any(galaxies,2)*(10^6-1));
r = rs(r);
c = cs(c)';
(sum(abs(c-c') + abs(r-r'),"all"))/2