input = readlines("a07.txt");
tic
total_sum = 0;
for i=1:size(input,1)
    in = input(i);
    nums = str2double(extract(in,digitsPattern));
    calibration = nums(1);
    vals = nums(2:end);
    res = vals(1); vals = vals(2:end);
    v = rec(calibration, res, vals);
    if v == 1
        total_sum = total_sum + calibration;
    end
end
sprintf('%0.f',total_sum)
toc
function [v] = rec(calibration, res, remain_vals)
    v=0;
    if isempty(remain_vals)
        return
    end
    for i=1:3
        switch i
            case 1
                intermed_res = res + remain_vals(1);
            case 2
                intermed_res = res * remain_vals(1);
            case 3
                intermed_res = str2double([num2str(res) num2str(remain_vals(1))]);
        end
        if intermed_res > calibration
            continue
        end
        if intermed_res == calibration && numel(remain_vals) == 1
            v = 1;
            return
        end
        [v] = rec(calibration, intermed_res, remain_vals(2:end));
        if v == 1
            return
        end
    end
end