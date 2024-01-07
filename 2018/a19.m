input = readlines("a19.txt");
ip = input(1).extract(digitsPattern).double+1;
regs = zeros(1,6);
regs(1) = 1;
instructions = input(2:end);
while true
    if regs(ip)+1 <= length(instructions)
        regs = OP(instructions(regs(ip)+1), regs);
    else
        regs(ip) = regs(ip) - 1;
        break
    end 
    regs(ip) = regs(ip) + 1;
end
regs(1)

function reg = OP(op, reg)
% internal ordering of: addr, addi, mulr, muli, banr, bani, borr, bori,
% setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr
    op = op.split(' ');
    oper = op(1);
    op(1) = oper.replace(["addr", "addi", "mulr", "muli", "banr", "bani", "borr", "bori", ...
 "setr", "seti", "gtir", "gtri", "gtrr", "eqir", "eqri", "eqrr"],["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]);
    op = double(op);


    
    
    v3 = op(4)+1;
    if ismember(op(1),[9 10 13])
        v1 = op(2); % value A
    else
        v1 = reg(op(2)+1);
    end
    if ismember(op(1),[1 3 5 7 11 14])
        v2 = op(3); % value B
    elseif ~ismember(op(1),[8 9])
        v2 = reg(op(3)+1);
    end    

    if op(1) < 2 %addr, addi
        reg(v3) = v1 + v2;
    elseif op(1) < 4 %mulr, muli
        reg(v3) = v1 * v2;
    elseif op(1) < 6 % banr, bani
        reg(v3) = bitand(v1, v2);
    elseif op(1) < 8 % borr, bori
        reg(v3) = bitor(v1, v2);
    elseif op(1) < 10 % setr, seti
        reg(v3) = v1;
    elseif op(1) < 13 % gtir, gtri, gtrr
        reg(v3) = v1 > v2;
    else % eqir, eqri, eqrr
        reg(v3) = v1 == v2;
    end
end