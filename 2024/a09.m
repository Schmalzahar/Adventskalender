input = (char(readlines("a09.txt"))-'0');
sys = [];
i = 1;
id = 0;
type = 0;
space = {};
while true
    in = input(i);
    if type == 0
        sys = [sys repelem(id,in)];
        id = id + 1;
    else
        if in ~= 0        
            space = editSpace(space, in, size(sys,2)+1);
            sys = [sys repelem(-1,in)];
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
left = 0; right = 0;
while true
    group_og_idx = find(sys_sort == group_id);
    group_len = numel(group_og_idx);
    min_idx = [Inf 0]; % 1: index of new location, 2: size of new location
    for i=group_len:size(space,2)
        if ~isempty(space{i}) && min_idx(1) > space{i}(1) && group_og_idx(1) > space{i}(1)
            min_idx(1) = space{i}(1); min_idx(2) = i;
        end
    end
    if ~isinf(min_idx(1))
        space{min_idx(2)}(1) = [];
        % new gap at group_og_idx. Is there already a gap to the left or to
        % the right? Either a gap size 1 which is 1 index to the left, or a
        % gap sized 2 which is 2 indices to the left, e.g.
        for g=1:size(space,2)
            % left
            if ~isempty(space{g}) && any(space{g} == group_og_idx(1)-g) && left == 0
                left = g;
                space{g}(space{g} == group_og_idx(1)-g) = [];
            end
            % right
            if ~isempty(space{g}) && any(space{g} == group_og_idx(end)+g) && right == 0
                right = g;
                space{g}(space{g} == group_og_idx(end)+g) = [];
            end
        end

        % extend in both directions, or only left
        new_len = left + right + group_len;
        space = editSpace(space, new_len, group_og_idx(1)-left);
        left = 0; right = 0;
        if group_len ~= min_idx(2)
            space{min_idx(2)-group_len} = sort([min_idx(1)+group_len, space{min_idx(2)-group_len}]);
        end
        sys_sort(min_idx(1):min_idx(1)+group_len-1) = group_id;
        sys_sort(group_og_idx) = -1;        
    end     
    group_id = group_id - 1;
    if group_id == 0
        break
    end
end

res = 0:(numel(sys_sort)-1);
sys_sort(sys_sort<0) = NaN;
part2 = uint64(sum(res .* sys_sort,'omitnan'))

function space = editSpace(space, new_len, idx)
    if new_len <= size(space,2) && ~isempty(space{new_len})
        space{new_len} = sort([space{new_len} idx]);
    else
        space{new_len} = idx;
    end   
end