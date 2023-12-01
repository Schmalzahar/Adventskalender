%% Day 21
% part 1: 09:00-
ccc
lines = readlines("a21.txt");
i = 1;
search_var = '';
while true
    if isempty(lines)
        sprintf('%16.f',lpjj+pvrr)
        break
    end
    line = char(lines(i));
    spline = strsplit(line);
    if spline{1} == "root:"
        var1 = spline{2};
        var2 = spline{4};
        if exist(var1,'var')
            assignin('base',var2,eval(var1))
            search_var = var2;
            lines(i) = '';
        elseif exist(var2,'var')
            assignin('base',var1,eval(var2))
            search_var = var1;
            lines(i) = '';
        end
        i = i+1;
        if i > length(lines)
            i = 1;
            lines = lines(~(lines == ''));
        end
        continue
    elseif spline{1} == "humn:"                                                                 
        lines(i) = '';
        i = i+1;
        if i > length(lines)
            i = 1;
            lines = lines(~(lines == ''));
        end
        continue
    end
    if length(line) > 10
        if strcmp(spline{1}(1:end-1),search_var)
            rvar = spline{1}(1:4);
            var1 = spline{2};
            var2 = spline{4};
            if exist(var1,'var')                
                search_var = var2;
                othervar = var1;
                s = 1;
            elseif exist(var2,'var')
                search_var = var1;
                othervar = var2;  
                s = 2;
            else 
                i = i + 1;
                if i > length(lines)
                    i = 1;
                    lines = lines(~(lines == ''));
                end
                continue
            end
            switch spline{3}
                case '*'
                    assignin('base',search_var, eval(strcat(rvar,'/',othervar)))
                case '-'
                    if s == 1
                        assignin('base',search_var, eval(strcat(othervar,'-',rvar)))
                    else
                        assignin('base',search_var, eval(strcat(othervar,'+',rvar)))
                    end
                case '/'
                    if s == 1
                        assignin('base',search_var, eval(strcat(othervar,'/',rvar)))
                    else
                        assignin('base',search_var, eval(strcat(othervar,'*',rvar)))
                    end
                case '+'
                    assignin('base',search_var, eval(strcat(rvar,'-',othervar)))
            end
            lines(i) = '';
        end
    end
    try 
        t = strsplit(line,':');
        assignin('base',spline{1}(1:end-1),eval(t{2}))
        lines(i) = '';
    catch
        i = i+1;
        if i > length(lines)
            i = 1;
            lines = lines(~(lines == ''));
        end
        continue
    end
    if exist('root','var')
        break
    end
    i = i+1;
    if i > length(lines)
        i = 1;
        lines = lines(~(lines == ''));
    end
    continue    
end
%sprintf('%16.f',root)