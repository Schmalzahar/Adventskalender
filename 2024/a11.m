stones = readmatrix("a11.txt");


% stones and the number  of times they occur
stones=[stones; ones(1,numel(stones))];
blnk=75; % 6789664325

tic
for j=1:blnk
    % Get unique values and their multiplicity
    [next_stones, ~, idx] = unique(stones(1,:)); 
    counts = accumarray(idx, stones(2,:)');
    stones = [next_stones; counts'];
    next_stones=[];
    for i=1:numel(stones(1,:))
        stone=stones(1,i); mult=stones(2,i);        
        if stone == 0
            next_stone = 1;            
        elseif mod(digits(stone),2) == 0 
            d = 10^(digits(stone)/2);
            sec = mod(stone,d);
            fir = (stone - sec)/d;               
            next_stone = [fir sec];  
        else
            next_stone = 2024*stone;
        end 
        next_stones=[next_stones [next_stone; repelem(mult, numel(next_stone))]];
    end
    stones=next_stones;
end
toc

res = uint64(sum(stones(2,:)))

function out = digits(in)
    if in == 0
        out = 1;
    else
        out = floor(log10(in)+1);
    end
end