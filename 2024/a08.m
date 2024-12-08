map = char(readlines("a08.txt"));
freqs = unique(map(map ~= '.'));
part1_nodes = zeros([size(map),size(freqs,1)]);
part2_nodes = zeros([size(map),size(freqs,1)]);

for i=1:numel(freqs)
    [fx, fy] = find(map == freqs(i));
    for j=1:numel(fx)-1
        for k=j+1:numel(fx)
            a = [fx(j) fy(j)]; b = [fx(k) fy(k)];
            f_diff = a-b;
            part2_nodes(a(1),a(2),i) = 1;
            part2_nodes(b(1),b(2),i) = 1;
            res_node = {};
            res_node{1} = @(x) a + x*f_diff; res_node{2} = @(x) b - x*f_diff;
            for l = 1:2
                n = 1;
                while true
                    nod = res_node{l}(n);
                    if nod(1) > 0 && nod(1) <= size(map,1) && ...
                            nod(2) > 0 && nod(2) <= size(map,2)
                        if n == 1
                            part1_nodes(nod(1),nod(2),i) = 1;
                        end
                        part2_nodes(nod(1),nod(2),i) = 1;
                    else
                        break
                    end
                    n = n+1;
                end
            end           
        end
    end
end

part1 = sum(sum(part1_nodes,3)>0,'all')
part2 = sum(sum(part2_nodes,3)>0,'all')