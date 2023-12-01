input = readlines("input_21.txt");
tic
ingredients = arrayfun(@(x) strsplit(x,' '),extractBefore(input," (contains"),'UniformOutput',false);
allergens = arrayfun(@(x) strsplit(x,' '),erase(erase(extractAfter(input,"contains "),')'),','),'UniformOutput',false);
unique_allergens = unique([allergens{:}]);
possible_ing = struct;
multi_allergen = arrayfun(@(x) length(x{:}),allergens) > 1;
% Go through single allergens
for i=1:numel(unique_allergens)
    allergen = unique_allergens(i);
    all_id = arrayfun(@(x) length(x{:}) == 1 && strcmp(x{:},allergen),allergens);
    ingredient = ingredients(all_id);
    if height(ingredient) > 1
        inj = ingredient{1};
        for j=2:height(ingredient)
            inj = inj(ismember(inj,ingredient{j}));
        end
        possible_ing.(allergen) = inj;
    elseif ~isempty(ingredient)
        possible_ing.(allergen) = ingredient{:};
    else
        possible_ing.(allergen) = unique([ingredients{:}]);
    end
end
for i=find(multi_allergen)'
    allergen = allergens{i};
    ing = ingredients{i};
    for j = allergen
        possible_ing.(j) = possible_ing.(j)(ismember(possible_ing.(j),ing));
    end
end
while true
    for al = unique_allergens
        if numel(possible_ing.(al)) == 1
            to_remove = possible_ing.(al);
            for al2 = unique_allergens(unique_allergens ~= al)
                possible_ing.(al2) = possible_ing.(al2)(~ismember(possible_ing.(al2),to_remove));
            end
        end
    end
    if all(structfun(@(x) length(x),possible_ing)==1)
        break
    end
end
al_ing = string.empty;
f = fields(possible_ing);
for i=1:height(fields(possible_ing))
    al_ing = cat(2,al_ing,possible_ing.(f{i}));
end
res = 0;
for i=1:height(ingredients)
    res = res + length(ingredients{i}(~ismember(ingredients{i},al_ing)));
end
res
res2 = strjoin(al_ing,',')
toc