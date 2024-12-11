input = readmatrix("a11.txt");

stone_num = 0;

% do the numbers 0 to 9
stone_num_dic = dictionary;
for i=0:9
    stone_num_dic{i} = [];
    stones = i;
    next_stones = [];
    max_blink = 10;
    for blink=1:max_blink
        for j=1:numel(stones)
            % rule 1
            if stones(j) == 0
                % stones(j) = 1;
                next_stones = [next_stones 1]; % TODO: go to stone dict                 
            elseif mod(digits(stones(j)),2) == 0 % rule 2
                next_stones = [next_stones firstHalf(stones(j)) secondHalf(stones(j))];                
            else
                next_stones = [next_stones 2024*stones(j)];
            end            
        end
        stone_num_dic{i} = [stone_num_dic{i} numel(next_stones)];
        stones = next_stones; next_stones = [];
    end
end

%%

for i=1:numel(input)
    stones = input(i);
    next_stones = [];
    for blink=1:25
        for j=1:numel(stones)
            % rule 1
            if stones(j) == 0
                % stones(j) = 1;
                next_stones = [next_stones 1];
                continue
            end
            % rule 2
            if mod(digits(stones(j)),2) == 0
                next_stones = [next_stones firstHalf(stones(j)) secondHalf(stones(j))];
                continue
            end
            next_stones = [next_stones 2024*stones(j)];
        end
        stones = next_stones; next_stones = [];
    end
end


%%
global glob_dict
glob_dict = configureDictionary("double","cell");

rec(0,11)



%%
function [stone_num] = rec(stone, rem_blink)
global glob_dict    
    % rule 1
    if digits(stone) == 1
        if isKey(glob_dict, stone)
            test = 1;
        else
            glob_dict{stone} = [];
        end
    end
    if stone == 0
        next_stones = 1; % TODO: go to stone dict                 
    elseif mod(digits(stone),2) == 0 % rule 2
        next_stones = [firstHalf(stone) secondHalf(stone)];                
    else
        next_stones = 2024*stone;
    end 
    stone_num = numel(next_stones);
    if rem_blink == 1
        return
    end
    new_stone_num = 0;
    for s=1:numel(next_stones)
        next_stone = next_stones(s);
        if isKey(glob_dict, next_stone)
            todo = 1;
        else
            new_stone_num = rec(next_stones(s), rem_blink-1) + new_stone_num;
        end
    end
    stone_num = new_stone_num;
end

function out = digits(in)
    if in == 0
        out = 1;
    else
        out = floor(log10(in)+1);
    end
end

function out = firstHalf(in)
    in_str = char(num2str(in));
    out = str2double(in_str(1:end/2));
end

function out = secondHalf(in)
    in_str = char(num2str(in));
    out = str2double(in_str(end/2+1:end));
end