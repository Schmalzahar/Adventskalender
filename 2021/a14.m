%% Day 14
input = readcell("input_a14.txt");%,"OutputType","string");
polymer_template = input{1};
pair_insertion_rules(:,1) = input(2:end,1);
pair_insertion_rules(:,2) = input(2:end,2);
for i=1:size(pair_insertion_rules,1)
    temp = strsplit(pair_insertion_rules{i,1},' -');
    pair_insertion_rules{i,1} = temp{1};
end
pair_insertion_rules = string(pair_insertion_rules);

% New method: dont actually save the new polymer_template
noOfSteps = 40;
polymer = struct;
poly_start = polymer_template(1);
poly_end = polymer_template(end);
for j=1:length(polymer_template)-1
    fname = polymer_template(j:j+1);
    polymer = polyin(polymer, fname, 1);
   
end

for n=1:noOfSteps
    new_polymer = struct;
    all_fields = fieldnames(polymer);
    for i=1:numel(all_fields)
        % if field has entries
        field = all_fields{i};
        ocurnum = polymer.(field);
        if ocurnum > 0
            % Search for rule
            rule = pair_insertion_rules(field==pair_insertion_rules(:,1),2);
            nf1 = field(1)+rule;
            nf2 = rule+field(2);
            % apply the rule ocurnum of times
            new_polymer = polyin(new_polymer,nf1,ocurnum);
            new_polymer = polyin(new_polymer,nf2,ocurnum);
        end
    end
    polymer = new_polymer;
end
% Get result. The start and the end of the polynom always stay the same
res = polyCount(polymer,poly_start, poly_end);
result = max(res) - min(res(res~=0));
disp("Result is: "+result)

function polymer = polyin(polymer,field,num)
    current_fields = fieldnames(polymer);
    if ~ismember(field,current_fields)
        polymer.(field) = num;
    else
        polymer.(field) = polymer.(field) + num;
    end
end

function histogram = polyCount(polymer,poly_start,poly_end)
    histogram=zeros(1,26);
    fields = fieldnames(polymer);
    for n=1:numel(fields)
        field = fields{n};
        f1 = field(1);
        f2 = field(2);
        histogram(f1-64)=histogram(f1-64)+polymer.(field);
        histogram(f2-64)=histogram(f2-64)+polymer.(field);
    end
    % add 1 at poly start and poly end
    histogram(poly_start-64) = histogram(poly_start-64) + 1;
    histogram(poly_end-64) = histogram(poly_end-64) + 1;
    % divide by 2
    histogram = histogram./2;
end