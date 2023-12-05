tic
input = readlines('a05.txt');
seeds = input.extractAfter("seeds: ");
seeds = seeds(1).extract(digitsPattern).double';
map = cell(1,length(descriptions)-1);
locations = NaN(size(seeds));
descriptions = ["seed-to-soil map:", "soil-to-fertilizer map:", "fertilizer-to-water map:", "water-to-light map:", "light-to-temperature map:", "temperature-to-humidity map:", "humidity-to-location map:", "end" ];
for i=1:length(seeds)
    source = seeds(i);
    destination = [];
    % seed to soil
    for k=1:length(descriptions)-1
        map{k} = input(find(circshift((input ==descriptions(k)),1)):find(circshift(input == descriptions(k+1),-2))).extract(digitsPattern).double;        
        for j=1:size(map{k},1)
            if source>=map{k}(j,2) && source<=map{k}(j,2)+map{k}(j,3)-1
                destination = source - map{k}(j,2)+map{k}(j,1);
                break
            end
        end
        if isempty(destination)
            destination = source;
        end
        source = destination;
        destination = [];
    end
    locations(i) = source;
end
min(locations)
%% part 2
seedsPart2 = [];
i=1;
while true
    seedsPart2(end+1,:) = [seeds(i) seeds(i+1)];
    i = i+2;
    if i>length(seeds)
        break
    end
end
% seed to soil, etc
source = seedsPart2;
destination = [];
for k=1:length(descriptions)-1
    s = height(source);
    while true
        slow = source(1,1);
        shigh = source(1,1)+source(1,2)-1;
        for j=1:size(map{k},1)
            dlow = map{k}(j,2);
            dhigh = map{k}(j,2)+map{k}(j,3)-1;            
            if (dlow <= slow) && (shigh <= dhigh) % whole range included                
                range_mapped = source(1,:);
                range_unmapped = double.empty(0,2);             
            elseif (dlow <= slow) && (slow <= dhigh) && (dhigh <= shigh)
                range_mapped = [slow, dhigh - slow+1];
                range_unmapped = [dhigh+1, shigh-dhigh];         
            elseif (slow <= dlow) && (dlow <= shigh) && (shigh <= dhigh)
                range_mapped = [dlow, shigh - dlow + 1];
                range_unmapped = [slow, dlow - slow];
            elseif (slow <= dlow) && (dhigh <= shigh)
                range_mapped = [dlow, dhigh - dlow + 1];
                range_unmapped = [slow, dhigh - slow];
                range_unmapped_2 = [dhigh+1, shigh-dhigh];
                source(end+1,:) = range_unmapped_2;
                s = s+1;
            end
            if (shigh>=dlow) && (dhigh >= slow) % in range
                diff = map{k}(j,2)-map{k}(j,1);
                destination(end+1,:) = [range_mapped(1,1) - diff, range_mapped(1,2)];
                source = [range_unmapped;source(2:end,:)];   
                if ~isempty(range_unmapped)
                    slow = source(1,1);
                    shigh = source(1,1)+source(1,2)-1;
                end
            end
        end
        if s == height(source)
            destination(end+1,:) = source(1,:);
            source = source(2:end,:);            
        end
        s = s-1;
        if isempty(source)
            break
        end
    end   
    source = destination;
    destination = [];
end
min(source(:,1))
toc