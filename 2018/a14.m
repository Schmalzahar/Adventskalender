imax = 10^8;
recepies = zeros(1,imax);
recepies(1,1:6) = [3 7 1 0 1 0];
elve1 = 5; elve2 = 4;
x = 681901;
x_ = num2str(x)-'0';
tic
i = 7;
while true
    sum_ = recepies(elve1)+recepies(elve2);
    if sum_ < 10
        recepies(i) = sum_;
        i = i + 1;
    else
        recepies(i) = 1;
        recepies(i+1) = sum_ - 10;
        i = i + 2;
    end
    elve1 = mod(elve1 + recepies(elve1),i-1)+1;
    elve2 = mod(elve2 + recepies(elve2),i-1)+1;
    % part 1
    % if i >= x+10
    %     recepies(x+1:x+10)
    %     break
    % end
    % part 2
    if mod(i,1000000) == 0
        if ~isempty(strfind(recepies,x_))
            strfind(recepies,x_)-1
            break
        end
    end
end
toc
