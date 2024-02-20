input = readlines("a21.txt");
ip = input(1).extract(digitsPattern).double+1;

regs = zeros(1,6);
regs(1) = 13443336;
instructions = input(2:end);
instrc = instructions.split(' ');
oper = instrc(:,1);
instrc(:,1) = oper.replace(["addr", "addi", "mulr", "muli", "banr", "bani", "borr", "bori", ...
 "setr", "seti", "gtir", "gtri", "gtrr", "eqir", "eqri", "eqrr"],["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]);
instrc = double(instrc);
print = false;
regs2 = zeros(50000,1);
i=1;
tic
while true

    if regs(ip) == 28
        % test = 1;
        % print = true;
        regs2(i,1) = regs(2);
        i = i+1;
        if mod(i,100) == 0
            if length(unique(regs2(1:i,:))) ~= length(regs2(1:i,:))
                break
            end
        end
    end
    if regs(ip)+1 <= height(instrc)
        regs = OP(instrc(regs(ip)+1,:), regs);
    else
        regs(ip) = regs(ip) - 1;
        break
    end 
    regs(ip) = regs(ip) + 1;
end
toc
%%
k=1;
while ismember(regs2(i-k,1),regs2(1:i-k-1,1))
    k = k+1;
end
regs2(i-k,1)
%%
function reg = OP(op, reg)
% internal ordering of: addr, addi, mulr, muli, banr, bani, borr, bori,
% setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr   
    
    v3 = op(4)+1;
    if op(1) == 9 || op(1) == 10 || op(1) == 13
        v1 = op(2); % value A
    else
        v1 = reg(op(2)+1);
    end
    if op(1) == 1 || op(1) == 3 || op(1) == 5 || op(1) == 7 || op(1) == 11 || op(1) == 14
        v2 = op(3); % value B
    elseif op(1) ~= 8 && op(1) ~= 9
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