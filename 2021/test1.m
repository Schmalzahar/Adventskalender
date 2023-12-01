data = importdata("input_a17.txt");
m = textscan(strrep(data{1},'.',' '), "target area: x=%f  %f, y=%f  %f\n", 'Whitespace', '.');
[xa, xb, ya, yb] = m{:};

[v, u, k] = meshgrid(ya:-ya+1, floor(-0.5*(sqrt(8*xa+1)-1)):xb, 1:-2*ya);
p = min(u,k).*u - min(u,k).*(min(u,k)-1)/2;
q = k.*v - k.*(k-1)/2;
t = any(xa <= p & p <= xb & ya <= q & q <= yb, 3);
fprintf("%d %d\n", max(max(max(q, [], 3).*t)), sum(sum(t)));