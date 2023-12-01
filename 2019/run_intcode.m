function [out, code] = run_intcode(code, input_1, input_2, i, rel_base, run_forever, run_until_input, use_input)
%run_iuntcode Intcode for 2019 Day 2,5,7,9,11
if nargin  < 4
    i = 1;
end
if nargin < 5
    rel_base = 0;
end
if nargin < 6
    run_forever = false;
end
if nargin < 7
    run_until_input = false;
end
if i>1
    input_1 = input_2;
end
input_counter = 1;
out1 = 0;
inp1 = 0;
inp2 = 0;
if run_forever
    outputs = [];
end
while true
    op = code(i);
    opstr = char(num2str(op));
    if length(opstr)>1
        opcode = str2double(opstr(end-1:end));
    else
        opcode = str2double(opstr);
    end
    if opcode == 99
        break
    end
    
    if length(opstr) >= 3
        mode1 = str2double(opstr(end-2));                
    else
        mode1 = 0;
    end
    if mode1 == 1
%         inp1 = code(i+1);
        inp1 = i+1;
    elseif mode1 == 2
%         inp1 = code(code(i+1) + 1 + rel_base);
        inp1 = code(i+1) + 1 + rel_base;
    else
%         inp1 = code(code(i+1)+1);
        inp1 = code(i+1)+1;
    end
    if any(opcode == [1 2 5 6 7 8])
        if length(opstr) >= 4
            mode2 = str2double(opstr(end-3));
        else
            mode2 = 0;
        end
        if mode2 == 1
%             inp2 = code(i+2);
            inp2 = i+2;
        elseif mode2 == 2
            inp2 = code(i+2) + 1 + rel_base;
        else
%             inp2 = code(code(i+2)+1);
            inp2 = code(i+2)+1;
        end
    end
    if any(opcode == [1 2 7 8])
        if length(opstr) >= 5
            mode3 = str2double(opstr(end-4));
        else
            mode3 = 0;
        end
        if mode3 == 1
            out1 = i+3;
        elseif mode3 == 2
            out1 = code(i+3) + 1 + rel_base;
        else
            out1 = code(i+3)+1;
        end
    end
    % check if size will be surpassed    
    if out1 > length(code) || inp1 > length(code) || inp2 > length(code)
        maxl = max([out1 inp1 inp2]);
        code = [code repelem(0, maxl - length(code))];
    end
    switch opcode
        case 1
%             code(out1) = inp1 + inp2;
            code(out1) = code(inp1) + code(inp2);
            i = i+4;
        case 2
%             code(out1) = inp1 * inp2;
            code(out1) = code(inp1) * code(inp2);
            i = i+4;
        case 3
            if run_until_input
                if use_input
                    code(inp1) = input_1;
                    i = i+2;
                    use_input = false;
                else
                    out = {outputs i rel_base};
                    return
                end
            else
                if input_counter == 1
    %                 code(code(i+1)+1) = input_1;
                    code(inp1) = input_1;
                elseif input_counter == 2
    %                 code(code(i+1)+1) = input_2;
                    code(inp1) = input_2;
                end
                input_counter = input_counter + 1;
                i = i+2;
            end
        case 4
%             input_1 = inp1;
%             output = inp1;
            output = code(inp1);
            i = i+2;
            if run_forever
                outputs(end+1) = output;
            else
                out = [output i rel_base];
                return
            end
        case 5
%             if inp1 ~= 0
%                 i = inp2+1;
%             else
%                 i = i+3;
%             end
            if code(inp1) ~= 0
                i = code(inp2)+1;
            else
                i = i+3;
            end
        case 6
%             if inp1 == 0
%                 i = inp2+1;
%             else
%                 i = i+3;
%             end
            if code(inp1) == 0
                i = code(inp2)+1;
            else
                i = i+3;
            end
        case 7
%             if inp1 < inp2
%                 code(out1) = 1;
%             else
%                 code(out1) = 0;
%             end
%             i = i+4;
            if code(inp1) < code(inp2)
                code(out1) = 1;
            else
                code(out1) = 0;
            end
            i = i+4;
        case 8
%             if inp1 == inp2
%                 code(out1) = 1;
%             else
%                 code(out1) = 0;
%             end
%             i = i+4;
            if code(inp1) == code(inp2)
                code(out1) = 1;
            else
                code(out1) = 0;
            end
            i = i+4;
        case 9
%             rel_base = rel_base + inp1;
%             i = i+2;
            rel_base = rel_base + code(inp1);
            i = i+2;
    end   
end

if run_forever
    out = outputs;
else
    if nargin == 1
        out = code(1);
    else
        out = input_1;
    end
end