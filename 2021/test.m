% Advent of Code Day 17
input = "./input_a17.txt";
tic
data = regexp(fileread(input), 'x=([-\d]*)..([-\d]*), y=([-\d]*)..([-\d]*)', 'tokens');
data = cellfun(@str2num, data{:});

x0 = data(1);
x1 = data(2);
y0 = data(3);
y1 = data(4);

dx = 1:x1;
dy = y0:-y0;
t = 0:max(x1, -2*y0);

x = 0 + dx - t';
x(x < 0) = 0;
x = cumsum(x);
ix = x >= x0 & x <= x1;

y = 0 + dy - t';
y = cumsum(y);
y = permute(y, [1 3 2]);
iy = y >= y0 & y <= y1;

ind = ix & iy;

ans_1 = max(y(:,:,any(ind, [1,2])), [], 'all')

ans_2 = sum(sum(ind) > 0, 'all')
toc