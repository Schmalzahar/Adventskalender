ic= char(readlines('a18.txt'));
B = [1 1 1;1 0 1;1 1 1];
tmax = 1000;
t_fin = 1000000000;
owl = zeros(tmax,3);
maps = zeros([size(ic) tmax]);
t_last = 0;
cycle = false;
cycle_dat = [];
for t=1:tmax
    req1 = conv2(ic == '|',B,"same")>2;
    remain_open = ic == '.' & ~req1;
    new_wood = ic == '.' & req1;
    req2 = conv2(ic == '#',B,"same")>2;
    remain_wood = ic == '|' & ~req2;
    new_lumber = ic == '|' & req2;
    req3 = conv2(ic == '#',B,"same")>0 & conv2(ic == '|',B,"same")>0;
    remain_lumber = ic == '#' & req3;
    new_open = ic == '#' & ~req3;   
    ic(remain_open | new_open) = '.';
    ic(remain_wood | new_wood) = '|';
    ic(remain_lumber | new_lumber) = '#';
    owl(t,1) = sum(ic == '.','all');
    owl(t,2) = sum(ic == '|','all');
    owl(t,3) = sum(ic == '#','all');    
    % cycle detection
    if any((all(owl(t,:) == owl(1:t-1,:),2))) && ~cycle
        if t_last == t-1
            cycle = true;
            t_cyl = t;
        else
            t_last = t;
        end
    end
    if cycle
        cycle_dat(end+1) = sum(ic == '|','all') * sum(ic == '#','all');
        if length(cycle_dat) > 1 && cycle_dat(1) == cycle_dat(end)
            break
        end
    end
end
% sum(ic == '|','all') * sum(ic == '#','all')
cycle_len = length(cycle_dat)-1;
t_fin1 = t_fin - t_cyl;
cycle_dat(mod(t_fin1+1,cycle_len))