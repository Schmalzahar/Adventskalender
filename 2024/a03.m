input = readlines("a03.txt");
input = join(input(:));

mul_exp = 'mul\(\d{1,3},\d{1,3}\)';
do_exp = 'do\(\)';
dont_exp = "don\'t\(\)";

multis_match = regexp(input,mul_exp,'match');
multis = regexp(input,mul_exp);
dos = regexp(input,do_exp);
donts = regexp(input,dont_exp);

part1 = sum(arrayfun(@(x) eval(x), multis_match))

valid = 1:max(multis);

dont_thresholds = arrayfun(@(x) max([0 donts(donts <= x)]), valid);
do_thresholds = arrayfun(@(x) max([1 dos(dos <= x)]), valid);
valid(do_thresholds < dont_thresholds) = [];
valid_multis = multis_match(ismember(multis, valid));

part2 = sum(arrayfun(@(x) eval(x), valid_multis))

function out = mul(a,b)
    out = a*b;
end