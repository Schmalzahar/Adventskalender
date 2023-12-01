%% Part 8
% 08:49-09:11 part 1
% 09:11-09:37
tic
trees = char(readlines("a08.txt"))-'0';
visible = 2*size(trees,1)+2*(size(trees,2)-2);
max_score = 0;
for i=2:size(trees,1)-1
    for j=2:size(trees,2)-1
        % Check 4 directions
        % left, right, up, down
        left = trees(j,i-1:-1:1);
        right = trees(j,i+1:end);
        up = trees(j-1:-1:1,i)';
        down = trees(j+1:end,i)';
        tree = trees(j,i);
        if all(left<tree) || all(right<tree) || all(up<tree) || all(down<tree)
            visible = visible + 1;
        end
        % scenic score
        score = 1;
        for dir = {left, right, up, down}
            direc = dir{:};
            if all(tree>direc)
                i_score = length(direc);
            else
                i_score = find((tree > direc)==0,1);
            end
            score = score * i_score;
        end
        if score > max_score
            max_score = score;
        end
    end
end
toc
disp(visible)
disp(max_score)