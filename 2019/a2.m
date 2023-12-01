code = readmatrix("input_2.txt");
part = 1;
if part == 1
    code(2) = 12;
    code(3) = 2;
    res = run_intcode(code);
elseif part == 2
    b = false;
    while ~b
        for i1 = 0:99
            code(2) = i1;
            for i2 = 0:99
                code(3) = i2;
                if run_intcode(code) == 19690720
                    res = 100 * i1 + i2;
                    b = true;
                    break
                end
            end
            if b
                break
            end
        end
    end
end
disp("Result day 2 part "+part+": "+res)