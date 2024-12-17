input = readlines("a17.txt");
regs = str2double(extract(input(1:3),digitsPattern));
A = regs(1);
program = str2double(extract(input(5),digitsPattern));
out_list = prog(A,0,0, program);
% result
res = sprintf('%d,',out_list);
res(1:end-1)

% part 2 brute
A = 483647376;


Amin = 3.5184e+13;
Amax = 3e14;
A = Amin + 1.0e+12;
A_min_bin = Amin;
A_max_bin = Amax;
while true
    

    A = floor((A_min_bin + A_max_bin)/2);

    out_list = prog(A,0,0, program);

    equal_digs = sum(out_list == program');

    A_test1 = floor((A_min_bin + 3*A_max_bin)/4);
    A_test2 = floor((3*A_min_bin + A_max_bin)/4);

    out_list1 = prog(A_test1,0,0, program);
    if length(out_list1) > 16
        A_max_bin = A_test1;
        continue
    end
    out_list2 = prog(A_test2,0,0, program);
    if length(out_list1) < 15
        A_min_bin = A_test2;
        continue
    end

    equal_digs1 = sum(out_list1 == program')
    equal_digs2 = sum(out_list2 == program')

    if equal_digs1 > equal_digs2
        A_min_bin = A_test1;
    elseif equal_digs1 < equal_digs2
        A_max_bin = A_test2;
    else
        A_min_bin = Amin;
    end

    % if length(out_list) == 16
    %     test = 1;
    % end
    if length(out_list) == length(program)
        if all(out_list == program')
            A
            break
        end
    end
    % A = A + 1;
end

%%

function out_list = prog(A, B, C, program)
    ip = 1;
    regs = [A B C];
    out_list = [];
    while true
        instr = program(ip); 
        operand = program(ip+1);
        operand_combo = operand;
    
        if operand_combo > 3
            operand_combo = regs(operand_combo - 3);
        end    
    
        switch instr
            case 0
                % adv: division
                regs(1) = floor(regs(1) / 2^(operand_combo));
            case 1
                % bxl: bitwise XOR
                regs(2) = bitxor(regs(2), operand);
            case 2
                % bst: combo modulo 8
                regs(2) = mod(operand_combo, 8);
            case 3
                % jnz
                if regs(1) ~= 0
                    ip = operand + 1;
                    continue
                end
            case 4
                % bxc: bitxise XOR B and C
                regs(2) = bitxor(regs(2), regs(3));
            case 5
                % out
                out_list(end+1) = mod(operand_combo, 8);
            case 6
                % bdv
                regs(2) = floor(regs(1) / 2^(operand_combo));
            case 7
                % cdv
                regs(3) = floor(regs(1) / 2^(operand_combo));
        end  

        ip = ip + 2;
        if ip > numel(program)
            break
        end
    end
end