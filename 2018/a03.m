input = readlines("a03.txt").extractAfter(" @ ").extract(digitsPattern).double;
map = zeros(1000,1000);
for i = 1:height(input)
    map(input(i,1)+1:(input(i,1)+input(i,3)), input(i,2)+1:(input(i,2)+input(i,4))) = map(input(i,1)+1:(input(i,1)+input(i,3)), input(i,2)+1:(input(i,2)+input(i,4)))+1;
end
sum(map>1,'all')

