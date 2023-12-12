% from https://www.youtube.com/watch?v=g3Ms5e7Jdqo
input = readlines('a12.txt');
tic
total = 0;
global cache
cache = dictionary;
for i=1:height(input)
    line = input(i);
    cfg = char(line.extractBefore(' '));
    nums = line.extract(digitsPattern).double;
    % part 2
    cfg = repmat([cfg 63],1,5);
    cfg = cfg(1:end-1);
    nums = repmat(nums,5,1);
    total = total + count(cfg, nums);
end
format long
total
toc
function result = count(cfg, nums)
    global cache
    result = 0;
    if cfg == ""
        % only valid if no expected blocks are left, aka nums is empty
        if isempty(nums)
            result = 1;            
        end
        return
    end
    if isempty(nums)
        if ~ismember('#',cfg)
            result = 1;            
        end
        return
    end
    key = {{cfg, nums}};
    if isConfigured(cache) && isKey(cache, key)
        result = cache(key);
        return
    end
    
    if any(cfg(1) == '.?')
        % treat ? as .
        result = result + count(cfg(2:end), nums);
    end

    if any(cfg(1) == '#?')
        % treat ? as #. Is the next block a valid block?
        % First: must be enough springs left
        % Second: no operational springs within first nums(1)
        % Third: next spring must be operational. Either there are no left,
        % of it is operational
        if nums(1) <= length(cfg) && all(cfg(1:nums(1)) ~= '.') && ...
                (nums(1) == length(cfg) || cfg(nums(1)+1)~='#')
            result = result + count(cfg(nums(1)+2:end), nums(2:end));
        end
    end
    cache(key) = result;
end