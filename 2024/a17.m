clear all
input = readlines("a17.txt");
tic
regs = str2double(extract(input(1:3),digitsPattern));
A = regs(1);
program = str2double(extract(input(5),digitsPattern))';

res = sprintf('%d,',prog(A,0,0, program));
res(1:end-1)

candidates = 0;
for numberIdx = 1:numel(program)
    newCandidates = []; 
    for candidateIdx = 1:height(candidates)

        trialNumberOcta = zeros(1,16);
        trialNumberOcta(1:width(candidates)) = candidates(candidateIdx,:);

        opt = [];
        for t = 0:7
            trialNumberOcta(numberIdx) = t;
            trialNumberDec = bin2dec(reshape(dec2bin(trialNumberOcta,3)',1,[]));
            out = prog(trialNumberDec,0,0,program);
            if out(end - numberIdx + 1:end) == program(end - numberIdx + 1:end)
                opt = [opt t];
            end
        end
        if numberIdx == 1
            newCandidates = opt(:);
        else
            newCandidates = [newCandidates;...
                repelem(candidates(candidateIdx,:), numel(opt),1) opt(:)];
        end

    end
    candidates = newCandidates;
end

% back to dec
uint64(min(bin2dec(reshape(string(dec2bin(candidates,3)),[],16).join(""))))
toc

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