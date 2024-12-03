input = readlines("a05.txt");
nice = 0;
nice2 = 0;
for i=1:size(input,1)
    line = char(input(i))

    % does not contain: ab, cd, pq, xy
    exp1 = '(ab|cd|pq|xy)';
    test1 = regexp(line,exp1);
    if isempty(test1)
        % at least one letter twice in a row
        exp2 = '([a-z])\1';
        test2 = regexp(line,exp2);
        if ~isempty(test2)
            exp3 = '[aeiou]';
            test3 = regexp(line,exp3);
            if numel(test3) > 2
                nice = nice + 1;
            end
        end
    end
    exp4 = '(..).*?\1';
    test4 = regexp(line,exp4);
    if ~isempty(test4)
        exp5 = '(.).\1';
        test5 = regexp(line,exp5);
        if ~isempty(test5)
            nice2 = nice2 + 1;
        end
    end
        
end
nice
nice2