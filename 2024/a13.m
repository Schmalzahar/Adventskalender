input = readlines("a13.txt");
tokens = 0;
for m=1:4:numel(input)
    lines = str2double(extract(input(m:m+2),digitsPattern));
    price = lines(3,:)' + 10000000000000; % part2
    sol = linsolve(lines(1:2,:)', price);
    if all(lines(1:2,:)' * round(sol)-price == 0)
        tokens = tokens + dot(sol,[3 1]);
    end
end
uint64(tokens)