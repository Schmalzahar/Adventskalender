input = readlines("a04.txt")


% find the smallest sumber so the has has 5 leading zeros (at least)
n = 1;
while true
    out = mMD5(char(input + num2str(n)));
    if all(out(1:6) == '000000')
        break
    end
    n = n+1;
end
n
