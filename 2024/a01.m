input = double(readlines("a01.txt").split(" "));
tic
input = [input(:,1) input(:,4)];
s = sort(input);
res = sum(abs(diff(s,1,2)))

[h,a] = groupcounts(s(:,2));

% t  = sum(s(:,2) == s(:,2)',2);

score = 0;
for i=1:size(s,1)
    if any(s(i,1) == a)
        score = score + h(s(i,1) == a) * s(i,1);
    end
    
end
score
toc