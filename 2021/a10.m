%% Day 10.1
fileID = fopen('input_a10.txt','r');
formatSpec = '%c';
A = fscanf(fileID, formatSpec);
lines = strsplit(A,'\r');
type1 = '()';
type2 = '[]';
type3 = '{}';
type4 = '<>';
types = {type1,type2,type3,type4};
open_del = {'(','[','{','<'};
close_del = {')',']','}','>'};
points = 0;
scores = double.empty;
for i=1:size(lines,2)
    line = lines{i};
    line_split = strsplit(line,'\n');
    if isempty(line_split{1})
        line = line_split{2};
    else
        line = line_split{1};
    end

    % remove these patterns
    while true
        [line_after, reduced_bool] = reduceline(line,types);
        if isempty(line_after)
            break
        end
        if ~reduced_bool
            % Part one
            % Inspect line_after for closed_del
            if contains(line_after,close_del)
                % Task is to find the first one that is wrong
                num = inf;
                for close_deli = close_del                    
                    id_f = strfind(line_after,close_deli);
                    if ~isempty(id_f)
                        id_f = id_f(1); % if multiple are found
                        if id_f < num
                            num = id_f;
                        end
                    end
                end
                wrong_char = line_after(num);                
                switch wrong_char
                    case ')'
                        points = points + 3;
                    case ']'
                        points = points + 57;
                    case '}'
                        points = points + 1197;
                    case '>'
                        points = points + 25137;
                end
            else
                % Part two. Incomplete lines. Repair by closing them
                total_score = 0;
                for open_del_i = line_after(end:-1:1)
                    % find the matching close_del
                    switch open_del_i
                        case '('
                            point_score = 1;
                        case '['
                            point_score = 2;
                        case '{'
                            point_score = 3;
                        case '<'
                            point_score = 4;
                    end
                    total_score = 5 * total_score;
                    total_score = total_score + point_score;
                end
                scores(end+1) = total_score;                
            end
            break
        end
        line = line_after;
    end    
end

disp("Result part 1: "+points)
disp("Result part 2: "+median(scores))

function [line_after, reduced_bool] = reduceline(line,types)
    line_before = line;
    for typei = types
        line = erase(line,typei);
    end
    line_after = line;
    if strcmp(line_before, line_after)
        reduced_bool = false;
    else
        reduced_bool = true;
    end
end