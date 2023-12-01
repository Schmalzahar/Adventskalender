input = readmatrix("input_25.txt");
card = input(1);
door = input(2);
subject_number = 7;
value = 1;
loop_size = 0;
while value ~= card
    value = mod(value * subject_number,20201227);
    loop_size = loop_size + 1;
end
res = 1;
for i=1:loop_size
    res = mod(door * res,20201227);
end
fprintf('%d\n',res)
