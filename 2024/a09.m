input = (char(readlines("a09.txt"))-'0');
sys = [];
% set file system
i = 1;
id = 0;
id_free = -1;
type = 0;
while true
    in = input(i);
    if type == 0
        sys = [sys repelem(id,in)];
        id = id + 1;
    else
        if in ~= 0
            sys = [sys repelem(id_free,in)];
            id_free = id_free - 1;
        end        
    end
    i = i+1;
    type = ~type;
    if i>numel(input)
        break
    end
end
%% part 1
idx = numel(sys);
sys_sort = sys;
while true
    idx = find(sys_sort > -1,1,'last');
    free_sp = find(sys_sort <= -1, 1);
    if free_sp > idx
        break
    end
    sys_sort(free_sp) = sys_sort(idx);
    sys_sort(idx) = -1;
end

%% checksum
res = 0:(idx-1);
part1 = uint64(sum(res .* sys_sort(1:idx)))

%% part 2
sys_sort = sys;
group_id = sys(end);
while true
    group_og_idx = find(sys_sort == group_id);
    group_len = numel(group_og_idx);
    id_free = -1;
    while true         
        len_free_space = sum(sys_sort == id_free);
        if len_free_space == 0
            test = 1;
        end
        if len_free_space < group_len
            id_free = id_free - 1;
            if id_free < min(sys_sort)
                break
            end
            continue
        else            
            idx = find(sys_sort == id_free,group_len);
            sys_sort(idx) = group_id;
            sys_sort(group_og_idx) = NaN;
            break
        end        
    end
    group_id = group_id - 1;
    if group_id == 0
        break
    end
end

res = 0:(numel(sys_sort)-1);
sys_sort(sys_sort<0) = NaN;
part2 = uint64(sum(res .* sys_sort,'omitnan'))