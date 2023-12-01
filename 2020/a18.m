input = erase(readlines("input_18.txt"),' ');
s = 0;

for i=1:height(input)
    s = vpa(s) + bra(input(i));
end
s
function out = bra(line)
    fun = @(s)sprintf('.{%d}',find(cumsum((s=='(' )-(s==')'))<0,1)-1);
    fun1 = @(s)sprintf('.{%d}',find(cumsum((s=='(' )-(s==')'))<0,1));
%     lines = regexp(line,'\((??@fun($''))','match');
    lines = regexp(line,'(??@fun($''))','match');
    lines_with = regexp(line,'\((??@fun1($''))','match');
    if isempty(lines)
        % no parentheses left. Evaluate
        out = neval2(line);
        return
    end
    for i=1:length(lines)
        num = bra(lines(i));
        line = strrep(line,lines_with(i),num2str(num));
    end
    out = neval2(line);
end

function out = neval2(in)
    in = char(in);
    out = 0;
    while true
        plusses = strfind(in,'+');
        if isempty(plusses)
            out = neval(in);
            break
        end
        plus = plusses(1);
        il = 1;
        ir = 1;
        ev = in(plus);
        while true
            if plus-il < 1 || isnan(str2double(in(plus-il)))
                break
            end
            ev = append(in(plus-il),ev);
            il = il + 1;
        end
        while true
            if plus+ir > length(in) || isnan(str2double(in(plus+ir)))
                break
            end
            ev = append(ev,in(plus+ir));
            ir = ir + 1;
        end
        evv = eval(ev);
        in(plus-il+1:plus+ir-1) = repelem('A',length(plus-il+1:plus+ir-1));
        in = strrep(in,repelem('A',length(plus-il+1:plus+ir-1)),num2str(evv));
    end
end

function out = neval(in)
    in = char(in);
    out = 0;
    i = 1;
    s = '';
    op = 0;
    while true        
        if i>length(in) || isnan(str2double(in(i)))
            if op == 1
                out = eval(s);
                in(1:i-1) = repelem('A',i-1);
                in = strrep(in,repelem('A',i-1),num2str(out));
                if str2double(in) == out
                    return
                end
                i = 1;
                s = '';
                op = 0;
                continue
            else
                if i>length(in)
                    out = eval(s);
                    return
                end
                op = op + 1;                
            end
        end
        s = append(s,in(i));
        i = i+1;     
    end
end