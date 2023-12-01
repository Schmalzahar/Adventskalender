tic
input = readlines("input_22.txt");
p1 = str2double(input(2:(end)/2));
p2 = str2double(input((end+1)/2+2:end));
[winner,score] = playGame(p1,p2)
toc
function [winner,score] = playGame(p1,p2)
    prev = containers.Map;
    while true    
        if isempty(p1)
            score = sum(p2 .* (height(p2):-1:1)');
            winner = 2;
            break
        elseif isempty(p2)
            score = sum(p1 .* (height(p1):-1:1)');
            winner = 1;
            break
        end
        new_prev = cat(2,char(p1'),':',char(p2'));
        if isKey(prev,new_prev)
            winner = 1;
            score = sum(p1 .* (height(p1):-1:1)');
            break
        else
            prev(new_prev) = true;
        end

        c1 = p1(1);    
        c2 = p2(1);
        if length(p1)-1>=c1 && length(p2)-1>= c2
            % Sub-game
            p11 = p1(2:2+c1-1);
            p21 = p2(2:2+c2-1);
            [sub_win,~] = playGame(p11,p21);
            if sub_win == 1
                p1 = cat(1,p1(2:end),c1,c2);
                p2 = p2(2:end);
                winner = 1;
            elseif sub_win == 2
                p1 = p1(2:end);
                p2 = cat(1,p2(2:end),c2,c1);
                winner = 2;
            end
        else
            p1 = p1(2:end);
            p2 = p2(2:end);
            if c1>c2
                if isempty(p1)
                    p1 = cat(1,c1,c2);
                else
                    p1 = cat(1,p1,c1,c2);  
                end
                winner = 1;
            else
                if isempty(p2)
                    p2 = cat(1,c2,c1);
                else
                    p2 = cat(1,p2,c2,c1);
                end
                winner = 2;
            end
        end
    end
end