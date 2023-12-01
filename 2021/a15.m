%% Day 15
tic
map = char(readmatrix("input_a15.txt","OutputType","string"))-'0';
% find the path with lowest total risk
% k-times larger. k=5 for part 2
k=5;
ls_orig = size(map,1);
% make the map larger
map = repmat(map,k);
% add to the map
m1 = 0:k-1;
addmat = repelem(repmat(m1,k,1)+repmat(m1',1,k),ls_orig,ls_orig);
map = mod(map + addmat - 1, 9) + 1;
ls = size(map,1);
% build the graph   
of = ls*(ls-1); % offset
s = NaN(1,4*of);
t = NaN(1,4*of);
weights = NaN(1,4*of);
% Numeration begins at top left and goes right
for n=1:ls-1
    i1 = 1+(n-1)*ls;
    % First: all top down paths
    s(i1:n*ls) = (i1):(n*ls);
    t(i1:n*ls) = (1+n*ls):(ls+n*ls);
    weights(i1:n*ls) = map(n+1,:);    
    % down up
    s(of+i1:of+n*ls) = (1+n*ls):(ls+n*ls);
    t(of+i1:of+n*ls) = (i1):(n*ls);
    weights(of+i1:of+n*ls) = map(n,:); 
    % Then: left to right    
    s(2*of+i1:2*of+n*ls) = n:ls:(of+n);
    t(2*of+i1:2*of+n*ls) = (n+1):ls:(of+n+1);
    weights(2*of+i1:2*of+n*ls) = map(:,n+1)';
    % right to left
    s(3*of+i1:3*of+n*ls) = (n+1):ls:(of+n+1);
    t(3*of+i1:3*of+n*ls) = n:ls:(of+n);
    weights(3*of+i1:3*of+n*ls) = map(:,n)';

end
G = digraph(s,t,weights,ls*ls);
[spath,result] = shortestpath(G,1,ls*ls);
disp("Result is: "+result)
disp("Time: "+1000*toc+"ms")