a = char(readlines("a01.txt"));
sum(a(circshift(a,1)-a==0)-'0') % part 1
sum(a(circshift(a,length(a)/2)-a==0)-'0') % part 2