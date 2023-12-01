input = readlines("input_02.txt");
valid = 0;
part = 1;
for i=1:height(input)
    line = strsplit(input(i),': ');
    rule = line(1);
    letter = regexp(rule,'[a-z]','match');
    password = char(line(2));
    expected_amount = regexp(rule,'(\d*)-(\d*)','tokens');
    expected_amount = str2double(expected_amount{1});
    if part == 1
        match = regexp(password,letter);
        matches = length(match);        
        if expected_amount(1) <= matches && matches <= expected_amount(2)
            valid = valid + 1;
        end
    else
        pos1 = password(expected_amount(1));
        pos2 = password(expected_amount(2));
        if xor(pos1 == letter,pos2 == letter)
            valid = valid + 1;
        end
    end
end
valid