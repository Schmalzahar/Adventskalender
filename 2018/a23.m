input = readlines("a23.txt");
pos = input.extractBetween('<','>').split(',').double;
r = input.extractAfter('r=').double;
[rmax,I] = max(r);
loc = pos(I,:);
% collect the robots that are in range of robot I
in_range = 0;
for i=1:height(pos)
    nloc = pos(i,:);
    dist = sum(abs(nloc-loc)); 
    if dist <= rmax
        in_range = in_range + 1;
    end
end
in_range

%% Part 2:

new_cord = pos * [-1 1 1;1 -1 1;1 1 -1; 1 1 1]';
