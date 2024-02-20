input = readlines("a25.txt");
input = input.split(',').double;
constellations = NaN(height(input),1);
j = 1;
for i=1:height(input)
    dist = sum(abs(input(i,:)-input),2);
    if any(~isnan(constellations(dist<=3)))
        temp = constellations(dist<=3);
        t2 = temp(~isnan(temp));
        t2 = unique(t2);
        if height(t2) == 1
            constellations(dist<=3) = t2;
        else
            t3 = min(t2);
            constellations(dist<=3) = t3;
            for k=1:height(t2)
                t = t2(k);
                if t == t3
                    continue
                else
                    constellations(constellations == t) = t3;
                end

            end
        end
    else
        constellations(dist<=3) = j; j = j+1;
    end

end
size(unique(constellations),1)