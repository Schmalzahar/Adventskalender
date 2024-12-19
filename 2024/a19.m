input = readlines("a19.txt");
tic
towels = strtrim(strsplit(input(1),','));
designs = input(find(input == "")+1:end);

part1 = 0; part2 = 0;

for i=1:height(designs)
    res = towelCombinations(designs(i), towels);
    if res > 0
        part1 = part1 + 1;
    end
    part2 = part2 + res;
end
part1
uint64(part2)
toc
function number = towelCombinations(design,towels)
    persistent cache
    if isempty(cache)
        cache = configureDictionary("string","double");
    elseif isKey(cache,design)
            number = cache(design);
            return
    end
    number = 0;
    for t = towels
        if design.startsWith(t)
            trimmedDesign = design.extractAfter(strlength(t));
            if trimmedDesign == ""
                number = number + 1;
            else
                number = number + towelCombinations(trimmedDesign,towels);
            end
        end
    end
    cache(design) = number;
end