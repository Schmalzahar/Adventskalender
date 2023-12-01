code = readmatrix("input_7.txt");
% code = [3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,...
% -5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,...
% 53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10];
% out = run_intcode(code, 4,0)
% out = 0;
% sequence = [1,0,4,3,2];
max_out = 0;
max_seq = [];
s = 5:9;
[max_out, max_seq] = runSeq(code, [], s, max_out, max_seq);

max_out
max_seq


    

function [max_out, max_seq] = runSeq(code, currentSeq, remainSeq, max_out, max_seq)
    if length(remainSeq) > 1
        for si = remainSeq
            remainSeq(remainSeq == si) = [];
            [max_out, max_seq] = runSeq(code, [currentSeq si], remainSeq, max_out, max_seq);
            remainSeq = [remainSeq si];
        end
    else
        out = 0;
        sequence = [currentSeq remainSeq];
        i = 1;
        amp_pos = repelem(1,5);
        codes = repmat(code,5,1);
        while true
            [out,codes(i,:)] = run_intcode(codes(i,:), sequence(i), out, amp_pos(i));
            if length(out) == 1
                break
            end
            amp_pos(i) = out(2);
            out = out(1);
            if i < 5
                i = i+1;
            else
                i = 1;
            end
        end
        if out > max_out
            max_out = out;
            max_seq = sequence;
        end
    end
end