input = readlines('a04.txt');
guards = dictionary;
times = input.extractBetween('[',']');
info = input.extractAfter('] ');
% sort times
[times,b] = sort(datetime(times,'Format','yyyy-MM-dd HH:mm'));
info = info(b);
for i=1:height(info)
    line = info(i);
    if line.contains('Guard')
        guard_num = line.extract(digitsPattern).double;
    elseif line.contains('asleep')
        start_min = times(i).Minute;
    else
        end_min = times(i).Minute;
        if ~isConfigured(guards)
            guards{guard_num} = zeros(1,60);
        end
        if isKey(guards, guard_num)
            guards{guard_num}(max(1,start_min):end_min-1) = guards{guard_num}(max(1,start_min):end_min-1) + 1;
        else
            guards{guard_num} = [repelem(0,max(0,start_min-1)), repelem(1, end_min-max(1,start_min)), repelem(0,60-end_min+1)];
        end
    end 
end
vals = cell2mat(guards.values);
keys = guards.keys;
[~,sleepyGuard] = max(sum(vals,2));
[~,mostAsleep] = max(vals(sleepyGuard,:));
keys(sleepyGuard) * mostAsleep
% part 2
[~, mostMinuteInd] = max(vals,[],'all');
[guard_num, min] = ind2sub(size(vals), mostMinuteInd)
keys(guard_num) * min