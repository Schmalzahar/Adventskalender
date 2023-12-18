input = readlines("a18.txt");
points = [1 1];
% dirs = dictionary(['U';'D';'L';'R'],{[-1 0] [1 0] [0 -1] [0 1]}');
dirs = dictionary(['3';'1';'2';'0'],{[-1 0] [1 0] [0 -1] [0 1]}');
for i=1:height(input)
    line = input(i);
    dir = line.extractBefore(' ');
    len = line.extractBetween(' ', ' ').double();
    code = char(line.extractBetween('#',')'));
    dist_m = code(1:5);
    len = hex2dec(dist_m);
    dir = code(6);
    drc = dirs{dir};
    points(end+1,:) = points(end,:) + len.*drc;
end
poly = polyshape(points);
plot(poly)

% Picks theorem:
% A polygon with integer coordinates for all its vertices, i interior
% points, b points on the boundary that are integer points, then the area
% is A = i + b/2 - 1. With b being the perimiter, and with the fact that we
% need to count both the interior area and the perimiter, the result, i, is
format long
i = poly.area + poly.perimeter/2 + 1