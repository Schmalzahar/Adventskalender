input = readlines("input_6.txt");
planets = split(input,')');
comin = find(planets(:,1) == 'COM');
temp = planets(comin,:);
planets(comin,:) = [];
planets = [temp; planets];
G = graph(planets(:,1),planets(:,2));
dis = distances(G);
res1 = sum(dis(1,:))
res2 = length(shortestpath(G,"YOU","SAN"))-3