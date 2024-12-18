input = readlines("a17.txt");
regs = str2double(extract(input(1:3),digitsPattern));
A = regs(1);
program = str2double(extract(input(5),digitsPattern));
out_list = prog(A,0,0, program);
% result
res = sprintf('%d,',out_list);
res(1:end-1)

% part 2 brute
% A = 483647376;

A = 6*8^15; % 0
A = A + 5*8^14; % 3 
A = A + 5*8^13; % 5
A = A + 1*8^12; % 5
A = A + 1*8^11; % 5
A = A + 2*8^10; % 1
A = A + 1*8^9; % 3

% A = A + 6*8^8; % 0
A = A + 0*8^7;
% A = A + 0*8^6; % 2
A = A + 3*8^6;
A = A + 0*8^5; % 5
A = A + 1*8^4; % 7
A = A + 5*8^3; % 3
A = A + 2*8^2; % 1
A = A + 7*8^1; % 4
A = A + 7*8^0; % 2


while true
    

 
    A
    program'
    out_list = prog(A,0,0, program)



    

    % if length(out_list) == 16
    %     test = 1;
    % end
    if length(out_list) == length(program)
        if all(out_list == program')
            A
            break
        end
    end
    A = A+1*8^7;
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