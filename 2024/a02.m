input = readlines("a02.txt");
safep1 = 0;
safep2 = zeros(size(input));
for i=1:size(input,1)
    l = input(i);
    ll = double(l.extract(digitsPattern));
    d = diff(ll);
    % either all neg or all pos
    if all(d<0) || all(d>0)
        if max(abs(d))<4
            safep1 = safep1 + 1;
            safep2(i) = 1;
        end
    end  

    % remove one at a time
    for j=1:height(ll)
        if safep2(i) == 1
            break
        end
        lll = ll;
        lll(j) = [];
        dd = diff(lll);
        % either all neg or all pos
        if all(dd<0) || all(dd>0)
            if max(abs(dd))<4
                safep2(i) =  1;
            end
        end  
    end
end
safep1
sum(safep2)