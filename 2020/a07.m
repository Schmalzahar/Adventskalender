input = readlines("input_07.txt");
bags = extractBefore(input,' bags contain');
contents = extractAfter(input,'contain ');
containing_bags = findBags('shiny gold', bags, contents);
res = height(containing_bags)
number = countBags('shiny gold', bags, contents)

function containing_bags = findBags(bag, allbags, allcontents)
    containing_bags = allbags(contains(allcontents, bag));
    if isempty(containing_bags)
        return
    end
    new_containing_bags = containing_bags;
    for i=1:height(containing_bags)
        new_bags = findBags(containing_bags(i),allbags,allcontents);
        if ~isempty(new_bags)
            new_containing_bags = unique(cat(1,new_containing_bags,new_bags));
        end
    end
    containing_bags = new_containing_bags;
end

function number = countBags(bag, allbags, allcontents)
    bag_content = strsplit(allcontents(contains(allbags, bag)),', ');
    if bag_content == "no other bags."
        number = 0;
        return
    end
    number = 0;
    for i=1:width(bag_content)
        new_bag = regexp(bag_content(i),'\d\s(\w*\s\w*)\sbag','tokens');
        num = str2double(extract(bag_content(i),digitsPattern));
        new_number = countBags(new_bag{1}, allbags, allcontents);
        number = number + num + num * new_number;
    end
end