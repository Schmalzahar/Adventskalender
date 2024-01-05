input = readlines("a16.txt");


% the opcodes 0-15 could be anything at the start. We map them to the
% internal ordering of: addr, addi, mulr, muli, banr, bani, borr, bori,
% setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr
opcode_map = repelem({0:15},16,1);
% p1_sum = 0;
while true
    instruction_set = input(1:3);
    if contains(instruction_set(1),"Before")
        input(1:4) = [];
    else
        break
    end
    regStart = double(extract(instruction_set(1),digitsPattern))';
    instruction = double(extract(instruction_set(2),digitsPattern))';
    regEnd = double(extract(instruction_set(3),digitsPattern))';
    [opcode_map, p1] = getPossbOp(instruction, regStart, regEnd, opcode_map);
    % if p1 > 2
    %     p1_sum = p1_sum + 1;
    % end
end
% p1_sum
%% collect the known opcodes
known_op = NaN(1,16);
while any(isnan(known_op))
    known = find(cellfun(@(x) length(x) == 1,opcode_map));
    for i=1:numel(known)
        ki = known(i);
        known_op(ki) = opcode_map{ki};
    end
    % remove the known from the map
    for i=1:height(opcode_map)
        v = opcode_map{i};
        v = v(~ismember(v,known_op));
        opcode_map{i} = v;
    end
end

%% run the code
regs = zeros(1,4);
code = input(3:end);

for i=1:height(code)
    instruction = double(extract(code(i),digitsPattern))';
    regs = OP([known_op(instruction(1)+1) instruction(2:end)], regs);
end
regs(1)

%%
function [opcode_map, p1] = getPossbOp(instruction, regStart, regEnd, opcode_map)
    test = 1;
    % go through every possible option for the operator
    op_list = opcode_map{instruction(1)+1};
    corr_op = [];
    p1 = 0;
    for op = op_list
        regOp = OP([op instruction(2:end)], regStart);
        if all(regEnd == regOp)
            corr_op(1,end+1) = op;
            p1 = p1 + 1;
        end
    end
    opcode_map{instruction(1)+1} = corr_op; % comment out for part 1
end

function reg = OP(op, reg)
% internal ordering of: addr, addi, mulr, muli, banr, bani, borr, bori,
% setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr
    v1 = reg(op(2)+1);
    v2 = reg(op(3)+1);
    v3 = op(4)+1;
    if ismember(op(1),[9 10 13])
        v1 = op(2); % value A
    end
    if ismember(op(1),[1 3 5 7 11 14])
        v2 = op(3); % value B
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