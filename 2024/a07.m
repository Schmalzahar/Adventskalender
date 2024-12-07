input = readlines("a07.txt");
tic
total_sum = 0;
for i=1:size(input,1)
    in = input(i);
    nums = str2double(extract(in,digitsPattern));
    calibration = nums(1); vals = nums(2:end);
    if rec(calibration, vals, true)
        total_sum = total_sum + calibration;
    end
end
sprintf('%0.f',total_sum)
toc

% The idea is go start with the last number and check whether the operator
% is possible in this location. E.g. is calibration is 12345, then the last
% operator can only be || if n, i.e. vals(end) is either 5, 45, 345 etc.

function [v] = rec(calibration, vals, part2)
    head = vals(1:end-1); n = vals(end);
    if isempty(head)
        v = n == calibration;
        return 
    end
    % mult
    r = mod(calibration, n);
    if r == 0 && rec(calibration/n, head, part2)
        v = true;
        return
    end
    % || operator
    if part2 && endsWith(num2str(calibration), num2str(n)) && ...
            rec(floor(calibration/(10^floor(log10(n)+1))), head, part2)
        v = true;
        return
    end
    % add
    v = rec(calibration - n, head, part2);
end