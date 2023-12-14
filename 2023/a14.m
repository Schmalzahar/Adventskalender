input = char(readlines("a14.txt"));
tic
load = 0;
all_cyls = dictionary;
cyl = 1;
while true
    for d = 1:4 % change 4 to 1 for part 1
        for i=1:size(input,2)
            if mod(d,2) == 1
                line = input(:,i);
            else
                line = input(i,:);
            end
            if d > 2
                line = flip(line);
            end
            % cubes
            cubes = find(line == '#');
            rounds = find(line == 'O');
            new_rounds = zeros(size(rounds));
            for j=1:numel(rounds)
                blocked = cubes(find(cubes < rounds(j),1,'last'));
                if isempty(blocked)
                    new_rounds(j) = max(new_rounds) + 1;
                else
                    new_rounds(j) = max(blocked + 1, max(new_rounds)+ 1);
                end        
            end
            if d > 2
                new_rounds = height(input)+1 - new_rounds;
            end
            if mod(d,2) == 1
                input(input(:,i) == 'O',i) = '.';
                input(new_rounds,i) = 'O';    
            else
                input(i,input(i,:) == 'O') = '.';
                input(i, new_rounds) = 'O';    
            end
        end
    end
    load = sum(sum((input == 'O'),2) .* (height(input):-1:1)');

    if ~isConfigured(all_cyls) || ~isKey(all_cyls, {input})
        all_cyls{{input}} = [load cyl];
    else
        cycle_start_dur = all_cyls{{input}}(2) - 1;
        cycle_len = cyl - all_cyls{{input}}(2);
        break
    end
    cyl = cyl + 1;
end
% load
cyl_vals = values(all_cyls);
cyl_vals{mod(10^9-cycle_start_dur,cycle_len)+cycle_start_dur}(1)
toc