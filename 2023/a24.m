input = readlines('a24.txt');
p = zeros(height(input),3);
v = zeros(height(input),3);
% area = [7 27; 7 27];
area = [200000000000000 400000000000000; 200000000000000 400000000000000];
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
    yp1 = p(s1,2)+(xp-p(s1,1))*v(s1,2)/v(s1,1);
    yp2 = p(s2,2)+(xp-p(s2,1))*v(s2,2)/v(s2,1); % should be the same as yp1

    if (isinf(t1) || t1>0) && (isinf(t2) || t2>0) && (area(1,1) <= xp) && (xp <= area(1,2)) && ...
                (area(2,1) <= yp1) && (yp1 <= area(2,2))
        cross(j) = 1;
    end
end
sum(cross)

%% part 2
syms t [height(input) 1]
syms s [3 1]
syms w [3 1]
eqs = [];
for i=1:height(input)
    eqs = [eqs; eval(sprintf('p(i,:)'' - s == t%d*(w-v(i,:)'')',i))];
end

% manually simplify equation system so we can solve it
eqs1 = eqs(1:3:end); % system with w1 and s1. First, eliminate s1
eqs1_1 = subs(eqs1(2:end),s1,solve(eqs1(1),s1)); % 299 eqs with 301 unknowns. Second, eliminate w1
eqs1_2 = subs(eqs1_1(2:end),w1,solve(eqs1_1(1),w1)); % 298 eqs with 300 unknowns
eqs1_3 = simplify(eqs1_2);

eqs2 = eqs(2:3:end);
eqs2_1 = subs(eqs2(2:end),s2,solve(eqs2(1),s2));
eqs2_2 = subs(eqs2_1(2:end),w2,solve(eqs2_1(1),w2));
eqs2_3 = simplify(eqs2_2);

eqs3 = eqs(3:3:end);
eqs3_1 = subs(eqs3(2:end),s3,solve(eqs3(1),s3));
eqs3_2 = subs(eqs3_1(2:end),w3,solve(eqs3_1(1),w3));
eqs3_3 = simplify(eqs3_2);

eqs4 = [eqs1_3(1); eqs2_3(1); eqs3_3(1)];
S1 = solve(eqs4,[t1 t2 t3]);
% now, go through the rest (we dont actually need the other times though)
t_ar = zeros(300,1);
t_ar(1) = S1.t1; t_ar(2) = S1.t2; t_ar(3) = S1.t3;
for i=4:300
    t_ar(i) = solve(subs(eqs3_3(i-2),[t1 t2],[S1.t1 S1.t2]));
end

w1_sol = solve(subs(eqs1_1(1),[t1 t2],[S1.t1 S1.t2]));
w2_sol = solve(subs(eqs2_1(1),[t1 t2],[S1.t1 S1.t2]));
w3_sol = solve(subs(eqs3_1(1),[t1 t2],[S1.t1 S1.t2]));

s1_sol = solve(subs(eqs1(1),[t1, w1],[S1.t1, w1_sol]));
s2_sol = solve(subs(eqs2(1),[t1, w2],[S1.t1, w2_sol]));
s3_sol = solve(subs(eqs3(1),[t1, w3],[S1.t1, w3_sol]));
s1_sol+s2_sol+s3_sol