input = fliplr(readlines('a06.txt').extract(digitsPattern).double());
tic
% input = randi(100,100,2);
grid = zeros(max(input) - min(input)+1);
input_ind = sub2ind(size(grid),input(:,1)-min(input(:,1))+1,input(:,2)-min(input(:,2))+1);
grid(input_ind) = 1:height(input);
point_keys = (1:height(input))';
point_map = dictionary(point_keys, num2cell(input_ind,2));
new_point_map = dictionary(point_keys, num2cell(input_ind,2));
all_points = zeros(numel(grid),1);
all_points(1:height(input)) = input_ind;
round_points = [];
j = height(input) + 1;
grid(input_ind) = point_keys';
prev_grid = grid;
while true
    for i=1:height(input)
        points = new_point_map{i};
        new_point_map{i} = [];
        for k=1:numel(points)
            point = points(k);
            new_points = [min(point+1,floor((point-0.0001)/height(grid)+1)*height(grid)) max(point-1,floor((point-0.0001)/height(grid))*height(grid)+1) point+height(grid) point-height(grid)]';
            new_points(ismember(new_points,point_map{i}) | new_points <= 0 | new_points > numel(grid) | ismember(new_points, all_points)) = [];
            double_points = new_points(ismember(new_points,round_points));
            grid(double_points) = 0;
            actually_new_points = new_points(~ismember(new_points,round_points));
            new_point_map{i} = [new_point_map{i} new_points'];
            grid(actually_new_points) = i;
            round_points = [round_points; actually_new_points];
            point_map{i} = [point_map{i} new_points'];
        end
    end
    all_points(j:j+numel(round_points)-1) = round_points;
    j = j+numel(round_points);
    if all(grid == prev_grid,'all')
        break
    end
    prev_grid = grid;
    round_points = [];
end
% count
% remove edge elements
elements = unique([unique(grid(1:end,1));unique(grid(1:end,end));unique(grid(1,1:end))';unique(grid(end,1:end))']);
possible_keys = point_keys(~ismember(point_keys,elements));
max(arrayfun(@(x) sum(grid == x,'all'), possible_keys))
toc

%% part 2
% why did we do part 1?!?!??!?!

locations = input-min(input)+1;
max_dist = 10000;
dist_grid = zeros(max(input) - min(input)+1);
for i=1:height(locations)
    loc = locations(i,:);
    [X,Y] = meshgrid(abs(loc(2)-(1:width(dist_grid))), abs(loc(1)-(1:height(dist_grid))));
    dist_grid = dist_grid + X + Y;
    imagesc(dist_grid)
end

numel(dist_grid(dist_grid < max_dist))

max_dist_grid = dist_grid .* (dist_grid < max_dist);
figure()
imagesc(max_dist_grid)