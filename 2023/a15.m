input = readlines('a15.txt').split(',');
values = 0;
for i=1:height(input)
    value = 0;
    str = char(input(i));
    for j=1:length(str)
        ascii = str(j)-0;
        value = value + ascii;
        value = value * 17;
        value = mod(value, 256);
    end
    values = values + value;
end
values