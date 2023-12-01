masses = readmatrix("input_1.txt");
disp("Result day 1 part 1: "+ sum(arrayfun(@(x) floor(x/3)-2,masses)))
a = 0;
while ~isempty(masses)
    b = arrayfun(@(x) floor(x/3)-2,masses);
    masses = b(b>0);
    a = a + sum(masses);
end
disp("Result day 1 part 2: "+a)