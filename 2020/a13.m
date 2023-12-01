input = readlines("input_13.txt");
tic
busses = str2double(extract(input(2),digitsPattern))';
time = str2double(input(1));
start_time = time;
while true
    bmod = mod(time,busses) == 0;
    if any(bmod)
        bus = busses(bmod);
        res = bus * (time - start_time);
        disp("Result part 1: "+res)
        break
    end
    time = time + 1;
end
toc
%% Part 2, chinese remainder theorem
tic
busses = str2double(strrep(strsplit(input(2),','),'x','NaN'));
prev_remainder = 0; % the first remainder is zero
for i=1:length(busses)-1
    if isnan(busses(i+1))
        continue
    end
    [g,u,v] = gcd(prod(busses(1:i),'omitnan'),busses(i+1));
    new_remainder = busses(i+1) - i;
    if new_remainder < 0 
        new_remainder = new_remainder + ceil(-new_remainder/busses(i+1)) * busses(i+1);
    end % vpa needed for extra precision
    num1 = vpa(prev_remainder * busses(i+1) * v + new_remainder * prod(busses(1:i),'omitnan') * u);
    p = prod(busses(1:i+1),'omitnan');
    if num1 > 0
        num1 = num1 - floor(num1/p)*p;
    else
        num1 = num1 + ceil(-num1/p)*p;
    end
    prev_remainder = num1;
end
fprintf('Result part 2: %d\n',num1);
toc
%% Part 2, different implementation
tic
busses = str2double(strrep(strsplit(input(2),','),'x','NaN'));
M = prod(busses(1:end),'omitnan');
sol = 0;
for i=1:length(busses)
    if isnan(busses(i))
        continue
    end
    [g,u,v] = gcd(busses(i),M/busses(i));
    e_i = v * M/busses(i);
    new_remainder = busses(i) - i + 1;
    new_remainder = mod(new_remainder,busses(i));
    if i==1
        new_remainder = 0;
    end
    sol = vpa(sol) + e_i * new_remainder; % vpa needed for extra precision
end
sol = mod(sol,M);
fprintf('Result part 2: %d\n',sol);
toc