code = readmatrix("input_5.txt");
part = 2;
if part == 1
    inp1 = 1;
elseif part == 2
    inp1 = 5;
end
out = run_intcode(code, inp1,0,1,0,true);
res = out(end)