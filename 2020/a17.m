cubes = char(strrep(strrep(readlines("input_17.txt"),'#','1'),'.','0'))-'0';
cycles = 6;
tic
for i=1:cycles
    cubes = pad(cubes);
    new_cubes = cubes;
    s = size(cubes);
    N = length(s);
    [c1{1:N}] = ndgrid(1:3);
    c2(1:N) = {2};
    offsets = sub2ind(s,c1{:}) - sub2ind(s,c2{:});
    for xi=2:size(cubes,1)-1
        for yi=2:size(cubes,2)-1
            for zi=2:size(cubes,3)-1
                for wi=2:size(cubes,4)-1
                    % get neighbors
                    neighbors = cubes(sub2ind(s,xi,yi,zi,wi)+offsets);
                    % [3 4], because neighbors includes the 1 at the center
                    if cubes(xi,yi,zi,wi) == 1 && ~(any(sum(neighbors,"all") == [3 4]))
                        new_cubes(xi,yi,zi,wi) = 0;
                    end
                    if cubes(xi,yi,zi,wi) == 0 && sum(neighbors,"all") == 3
                        new_cubes(xi,yi,zi,wi) = 1;
                    end
                end
            end
        end
    end
    cubes = new_cubes(2:end-1,2:end-1,2:end-1,2:end-1);
end
sum(cubes,"all")
toc
function out = pad(mat)
    s = size(mat);
    N = length(s);
    if N == 2
        s = [s 1];
        % Part 2
        s = [s 1];
    end
    new_s = s + 4;
    out = zeros(new_s);
    out(3:end-2,3:end-2,3:end-2,3:end-2) = mat;
end