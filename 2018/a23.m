input = readlines("a23.txt");
pos = input.extractBetween('<','>').split(',').double;
r = input.extractAfter('r=').double;
[rmax,I] = max(r);
loc = pos(I,:);
d = zeros(height(pos),1);
% collect the robots that are in range of robot I
in_range = 0;
q = PriorityQueue();
for i=1:height(pos)
    nloc = pos(i,:);
    dist = sum(abs(nloc-loc));
    d(i) = sum(abs(pos(i,:)));
    q.pushMin([max(0,d(i)-r(i)) 1]);
    q.pushMin([d(i)+r(i)+1, -1]);
    if dist <= rmax
        in_range = in_range + 1;
    end
end
in_range

%% Part 2:
count = 0; maxCount = 0; result = 0;
while ~isempty(q.items)
    it = q.popNP;
    dist = it(1); e = it(2);
    count = count + e;
    if count > maxCount
        result = dist;
        maxCount = count;
    end
end