lines = readlines("a07.txt");
lines_split = arrayfun(@(x) strsplit(x,' -> '),lines,'UniformOutput',false);
candidates = []; branches = [];
for i=1:length(lines_split)
    if size(lines_split{i},2)>1
        test = lines_split{i};
        testspl = strsplit(test(1),' ');
        candidates = [candidates; testspl(1)];
        new_b = regexp(test(2),'\w+','match');
        lines_split{i} = test(1);
        branches = [branches; new_b repmat("",1,7-size(new_b,2))];
    end
end

weights = str2double(cellfun(@(x) extract(x,digitsPattern), lines_split));
original_weights = weights;
names = cellfun(@(x) extract(x,lettersPattern), lines_split);
for i=1:length(candidates)
    if ~ismember(candidates(i),branches)
        candidates(i)
    end
end
break_flag = false;
while ~break_flag
    remove_flag = false(size(candidates));
    for i=1:length(candidates)        
        cand = candidates(i);    
        % end points
        stacks = branches(i,~ismissing(branches(i,:),""));
        if ~any(ismember(stacks, candidates))            
            w = weights(stacks(1) == names);
            weight_array = w;
            for j=2:length(stacks)                
                if w ~= weights(stacks(j) == names)
                    break_flag = true;
                end
                weight_array = [weight_array; weights(stacks(j) == names)];
            end
            weights(names == cand) = weights(names == cand) + sum(weight_array);
            remove_flag(i) = true;
        end
        if break_flag
            break
        end
    end
    branches = branches(~remove_flag,:);
    candidates = candidates(~remove_flag);
    if break_flag
        old_weight = original_weights(names == stacks(weight_array~=mode(weight_array)));
        new_weight = old_weight + mode(weight_array) - weight_array(weight_array~=mode(weight_array))
    end
end


