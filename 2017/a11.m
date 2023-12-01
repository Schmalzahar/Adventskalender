input = split(char(readlines("a11.txt")),',');
n = 0;
ne = 0;
nw = 0;
max_steps = 0;
for i=1:length(input)
    dir = input{i};
    switch dir
        case 'n'
            n = n+1;
        case 'ne'
            ne = ne+1;
        case 'nw'
            nw = nw + 1;
        case 's'
            n = n - 1;
        case 'sw'
            ne = ne - 1;
        case 'se'
            nw = nw - 1;
    end
    cur_steps = countSteps(n,ne,nw);
    if cur_steps > max_steps
        max_steps = cur_steps;
    end
end
countSteps(n,ne,nw)
function steps = countSteps(n, ne, nw)
    %steps
    min_steps = sum(abs([n ne nw]));
    while true
        if (ne>0 && nw>0) % north
            n = n + min([ne nw]);
            if ne < nw
                nw = nw - ne;
                ne = 0;
            else
                ne = ne - nw;
                nw = 0;
            end
        elseif ne<0 && nw<0 % south
            n = n - min(abs([ne nw]));
            if ne < nw
                ne = ne - nw;
                nw = 0;
            else
                nw = nw - ne;
                ne = 0;
            end
        elseif ne>0 && n<0 % se
            nw = nw - min(abs([n ne]));
            if ne > -n
                ne = ne + n;
                n = 0;
            else
                n = n + ne;
                ne = 0;
            end
        elseif nw>0 && n<0 % sw
            ne = ne - min(abs([nw n]));
            if -n>nw
                n = n + nw;
                nw = 0;
            else
                nw = nw + n;
                n = 0;
            end
        elseif n > 0 && ne < 0 % nw
            nw = nw + min(abs([n ne]));
            if n > -ne
                n = n + ne;
                ne = 0;
            else
                ne = ne + n;
                n = 0;
            end
        elseif n>0 && nw < 0 % ne
            ne = ne + min(abs([n nw]));
            if n > -nw
                n = n + nw;
                nw = 0;
            else
                nw = nw + n;
                n = 0;
            end
        end
        steps = sum(abs([n ne nw]));
        if steps < min_steps
            min_steps = steps;
        else
            break
        end
    end
    steps = min_steps;
end