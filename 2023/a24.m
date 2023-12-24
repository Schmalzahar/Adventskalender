input = readlines('a24.txt');
p = zeros(height(input),3);
v = zeros(height(input),3);
area = [2 4; 2 4].*10^14;
for i=1:height(input)
    line = input(i).split(' @ ');
    p(i,:) = line(1).split(', ').double()';
    v(i,:) = line(2).split(', ').double()';
end
%% part 1
tests = nchoosek(1:height(input),2);
cross = zeros(height(tests),1);

for j=1:height(tests)
    s1 = tests(j,1); % first stone
    s2 = tests(j,2); % second stone
    xp = (p(s1,2)-p(s2,2) + v(s2,2)*p(s2,1)/v(s2,1) - v(s1,2)*p(s1,1)/v(s1,1))/...
        (v(s2,2)/v(s2,1) - v(s1,2)/v(s1,1));
    t1 = (xp-p(s1,1))/v(s1,1);
    t2 = (xp-p(s2,1))/v(s2,1);
    yp = p(s1,2)+(xp-p(s1,1))*v(s1,2)/v(s1,1);
    if t1>0 && t2>0 && area(1,1) <= xp && xp <= area(1,2) && ...
                area(2,1) <= yp && yp <= area(2,2)
        cross(j) = 1;
    end
end
sum(cross)
%% part 2
syms t [3 1] % time
syms s [3 1] % position
syms w [3 1] % velocity
eqs = [];
% we only need the first three stones, so we have 9 unknowns and 9 eqs
for i=1:3
    eqs = [eqs; eval(sprintf('p(i,:)'' - s == t%d*(w-v(i,:)'')',i))];
end
solution = solve(eqs,[t s w]);
solution.s1 + solution.s2 + solution.s3