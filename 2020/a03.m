input = readlines("input_03.txt");
r = [1 3 5 7 1];
d = [1 1 1 1 2];
count_mult = 1;
for j=1:numel(r)
    rj = r(j);
    dj = d(j);
    count = 0;
    for i=1:(height(input)-1)/dj
        line = char(input(1+dj*i));
        check = circshift(line,-i*rj);
        if check(1) == '#'
            count = count + 1;
        end
    end
    count_mult = count_mult * count;
end
sprintf('%d',count_mult)