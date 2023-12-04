input = readlines("a04.txt");
points = 0;
cardoccurances = ones(height(input),1);
for i=1:height(input)
    line = input(i).split({': ','|'});
    winning = str2double(extract(line(2),digitsPattern));
    myNumbers = str2double(extract(line(3),digitsPattern));
    matches = sum(ismember(myNumbers,winning));
    if matches>0
        points = points + 2^(matches-1);
        cardoccurances(i+1:i+matches) = cardoccurances(i+1:i+matches) + cardoccurances(i);
    end    
end
points
sum(cardoccurances)