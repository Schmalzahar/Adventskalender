rmin = 240920;
rmax = 789857;
pwc = 0;
tic
for i=244444:788999
    % at least two adjacent digits are the same
    a = num2str(i)-'0';
    %% Part 1
%     if all(a(2:end)-a(1:end-1) >= 0) && any(a(2:end)-a(1:end-1) == 0)
%         pwc = pwc + 1;
%     end
    %% Part 2
    if all(a(2:end)-a(1:end-1) >= 0)
        [N,~] = histcounts(a,1:10);
        if any(N==2)
            pwc = pwc + 1;
        end
    end
end
pwc
toc