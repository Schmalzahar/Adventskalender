input = char(readlines("a21.txt"));
input = repmat(input,31,31);
map = zeros(size(input));
S = find(input == 'S');
S = S(ceil(height(S)/2));
map(S) = 1;
map(input == '#') = NaN;

data = zeros(1501,2);
for i=1:500
    orgs = find(map == 1);    
    norgs = [orgs+1, orgs-1, orgs+height(input), orgs-height(input)];
    norgs(norgs<1) = []; norgs(norgs>numel(input)) = [];
    norgs(ismember(norgs,find(isnan(map)))) = [];
    map(orgs) = 0;
    map(norgs) = 1;
    % imagesc(map)
    data(i+1,:) = [i, sum(map == 1,'all')];
end
sum(map == 1,'all')
map(isnan(map)) = 2;
imagesc(map)
%%
% d_data = diff(data(100:500,2));
% dd_data = diff(d_data);
% pattern_diff = d_data(32:42)-d_data(21:31);
% extended_diff_data = d_data(1:31);
% extended_data = data(1:100,:);
d_data = diff(data(300:700,2));
dd_data = diff(d_data);
pattern_diff = d_data(234:364)-d_data(103:233);
extended_diff_data = d_data(1:233);
extended_data = data(1:300,:);
for i=1:250000
    extended_diff_data(end+1:end+length(pattern_diff),1) = i.*pattern_diff + d_data(103:233);
end

rhs = cumsum([extended_data(end,2) extended_diff_data'])';
extended_data(end+(1:(numel(extended_diff_data))),:) = [extended_data(end,1)+(1:numel(extended_diff_data))' rhs(2:end) ];

format long
extended_data(26501366,2)
%%

plot(extended_data(:,1),extended_data(:,2))
hold on
plot(data(:,1),data(:,2))