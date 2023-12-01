%% Day 7
horpos = readmatrix("input_a07.txt");
%% 7.1
result = fminbnd(@(x) sum(abs(horpos-x)),min(horpos),max(horpos));
disp("The result is: "+sum(abs(horpos-result)));
%% 7.2
result = fminbnd(@(x) sum(arrayfun(@getfuel, round(horpos-x))),min(horpos),max(horpos));
disp("The result is: "+sum(arrayfun(@getfuel, round(horpos-result))));

function fuel = getfuel(steps)
    steps = abs(steps);
    if steps == 1
        fuel = 1;
    else
        fuel = steps + getfuel(steps-1);
    end
end