%% Day 22
input = fileread("input_a22.txt");
input = strtrim(strsplit(input,newline));
cubes_on = [];
cubes_off = [];
%allowed_range = -50:50;
for i=1:width(input)
    line = input{i};
    onoff = strsplit(line," ");
    onoff = onoff{1};
    coords = regexp(line,"x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)","tokens");
    coords = str2double(string(coords{:}));
    x = [coords(1) coords(2)];
    y = [coords(3) coords(4)];
    z = [coords(5) coords(6)];
    noOfCubes = width(x(1):x(2))*width(y(1):y(2))*width(z(1):z(2));
    if strcmp(onoff,"on")
        cubes_on(end+1,:) = [x y z];
    else
        cubes_off(end+1,:) = [x y z];
    end
%     c1 = coords(1):coords(2);
%     c2 = coords(3):coords(4);
%     c3 = coords(5):coords(6);
%     if all(ismember(c1,allowed_range)) && all(ismember(c2,allowed_range)) && all(ismember(c3,allowed_range))
%     else
%         continue
%     end
%     cubes = zeros(width(c1)*width(c2)*width(c3),3);
%     k = 1;
%     for k1=1:width(c1)
%         for k2 = 1:width(c2)
%             for k3 = 1:width(c3)
%                 cubes(k,:) = [c1(k1) c2(k2) c3(k3)];
%                 k = k+1;
%             end
%         end
%     end
%     if strcmp(onoff, "on")
%         cubes_on= cat(1,cubes_on,cubes);
%         cubes_on = unique(cubes_on,"rows");
%     else
%         %todo
%         to_remove = cubes(ismember(cubes,cubes_on,"rows"),:);
%         cubes_on(ismember(cubes_on,to_remove,"rows"),:) = [];
%     end
end
%% 
% Advent of Code Day 22
input = "input_a22.txt";
data = fileread(input);
data(data == '.') = ' ';
data = textscan(data, '%s x=%d%d,y=%d%d,z=%d%d');

light = strcmp(data{1}, 'on');
x = sort([data{2}, data{3}], 2);
y = sort([data{4}, data{5}], 2);
z = sort([data{6}, data{7}], 2);
cubes = [light, x, y, z];

% Part 1
n = size(cubes,1);
cube = zeros(101,101,101);
offset = 51;
for i = 1:n
  c = cubes(i,:);
  if any(c < -50 | c > 50)
    continue;
  end
  cube(offset + (c(2):c(3)), offset + (c(4):c(5)),  offset + (c(6):c(7))) = c(1);
end

ans_1 = sum(cube, 'all')

%% Part 2
cube_set = [];
for i = 1:n
  b = cubes(i,:);
  new_cubes = [];
  old_cubes = [];
  if b(1) == 1
    new_cubes = b;
  end
  for j = 1:size(cube_set, 1)
    a = cube_set(j,:);
    if overlap(a, b)
      split_cubes = cube_split(a,b);
      new_cubes = [new_cubes; split_cubes];
      old_cubes(end+1) = j;
    end
  end
  cube_set(old_cubes,:) = [];
  cube_set = [cube_set; new_cubes];
end

ans_2 = cube_prod(cube_set);
fprintf('ans_2: %.0f\n', ans_2)

function match = overlap(a, b)
  match = false;
  xyz0 = max([a([2,4,6]); b([2,4,6])]);
  xyz1 = min([a([3,5,7]); b([3,5,7])]);
  if all(xyz0 <= xyz1, 'all')
    match = true;
  end
end

function [cubes] = cube_split(a,b)
  xyz0 = max([a([2,4,6]); b([2,4,6])]);
  xyz1 = min([a([3,5,7]); b([3,5,7])]);
	c = [b(1) xyz0(1), xyz1(1), xyz0(2), xyz1(2), xyz0(3), xyz1(3)];
 
  a1 = a; a2 = a; a3 = a; a4 = a; a5 = c; a6 = c;
  a1(3) = c(2) - 1;
  a2(2) = c(3) + 1;
  a3(2) = c(2); a3(3) = c(3); a3(5) = c(4) - 1;
  a4(2) = c(2); a4(3) = c(3); a4(4) = c(5) + 1;
  a5(1) = a(1); a5(6) = a(6); a5(7) = c(6) - 1;
  a6(1) = a(1); a6(7) = a(7); a6(6) = c(7) + 1;
  
  cubes_a = [a1; a2; a3; a4; a5; a6];
  valid_a = cubes_a(:,2) <= cubes_a(:,3) & cubes_a(:,4) <= cubes_a(:,5) & cubes_a(:,6) <= cubes_a(:,7);
  cubes = cubes_a(valid_a,:);
end

function p = cube_prod(a)
  p = sum(prod(a(:,3:2:end) - a(:,2:2:end) + 1, 2));
end

function plot_cube(ax, a)
  for i = 1:size(a,1)
    px = [a(i,2) a(i,2) a(i,3) a(i,3) a(i,2) a(i,2) a(i,2) a(i,3) a(i,3) a(i,2) a(i,2) a(i,2) a(i,3) a(i,3) a(i,3) a(i,3)];
    py = [a(i,5) a(i,4) a(i,4) a(i,5) a(i,5) a(i,5) a(i,4) a(i,4) a(i,5) a(i,5) a(i,4) a(i,4) a(i,4) a(i,4) a(i,5) a(i,5)];
    pz = [a(i,6) a(i,6) a(i,6) a(i,6) a(i,6) a(i,7) a(i,7) a(i,7) a(i,7) a(i,7) a(i,7) a(i,6) a(i,6) a(i,7) a(i,7) a(i,6)];
    plot3(ax, px, py, pz, 'o-');
  end
end

function plot_cube2(ax, a)
  for i = 1:size(a,1)
    x = reshape(a(i, [0, 1, 0, 0, 0, 0;
                      0, 1, 0, 0, 0, 0;
                      0, 1, 1, 1, 1, 1;
                      0, 1, 1, 1, 1, 1] + 2), [4,6]);
    y = reshape(a(i, [1, 1, 0, 1, 0, 0;
                      1, 1, 0, 1, 1, 1;
                      0, 0, 0, 1, 1, 1;
                      0, 0, 0, 1, 0, 0] + 4), [4,6]);
    z = reshape(a(i, [0, 0, 0, 0, 1, 0;
                      1, 1, 1, 1, 1, 0;
                      1, 1, 1, 1, 1, 0;
                      0, 0, 0, 0, 1, 0] + 6), [4,6]);
    fill3(ax, x, y, z, 'r');
  end
end