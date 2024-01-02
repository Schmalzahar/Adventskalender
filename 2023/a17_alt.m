input = char(readlines("a17.txt"))-'0';
tic
start_pos = [1 1];
fin = size(input);
H = height(input); W = width(input);

seen = zeros(height(input),width(input),4,3);

pq = PriorityQueue();
pq.push([1 1 1 0], 0); %  r, c, dir, n; hl
pq.push([1 1 2 0], 0);

dirs = [0 1; 1 0; 0 -1; -1 0]'; % right, down, left, up
while ~isempty(pq.items)
    [rcdirn, hl] = pq.pop;
    r = rcdirn(1); c = rcdirn(2); dir = rcdirn(3); n = rcdirn(4);
    if r == 1 && c == 1
        tes = 1;
    end

    if r == fin(1) && c == fin(2)
        hl
        break
    end
    if n>0
        if seen(r,c,dir,n) == 1
            continue
        else
            seen(r,c,dir,n) = 1;
        end
    end

    if n < 3 % same dir
        nr = r+dirs(1,dir);
        nc = c+dirs(2,dir);
        if 1 <= nr && nr <= H ...
                && 1 <= nc && nc <= W
            pq.push([nr nc dir n+1], hl+input(nr,nc));
        end
    end
    
    for d = 1:width(dirs)
        if d ~= dir && mod(d + 1,4)+1 ~= dir
            nr = r+dirs(1,d);
            nc = c+dirs(2,d);
            if 1 <= nr && nr <= H ...
                    && 1 <= nc && nc <= W
                pq.push([nr nc d 1], hl+input(nr,nc));
            end
        end
    end
end
toc