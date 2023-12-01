input = readlines("input_19.txt");
for i=1:height(input)
    if input(i) == ""
        break
    end
end
rules = input(1:i-1);
messages = input(i+1:end);
% Determine all possible messages that are correct. All messages must match
% rule 0
rule_num = str2double(extractBefore(rules,':'));
rules = extractAfter(rules,': ');
[rule_num,sid] = sort(rule_num);
rules = rules(sid);
% if (max(rule_num) - min(rule_num) + 1) ~= height(rules)
%     % rules are missing. Fill with empty rules
%     all_rule_num = (min(rule_num):max(rule_num))';
%     all_rules = string.empty(height(all_rule_num),0);
%     all_rules(ismember(all_rule_num,rule_num)) = rules;
%     rules = all_rules';
% end
part = 2;

tic
cms = findCorrectMessages(rules);

rule_0 = cms{1};
rule_0_rules = extract(rule_0,digitsPattern);
%%
s = 0;
rule31 = cms{32};
rule42 = cms{43};
len31 = width(rule31);
len42 = width(rule42);

for i=1:height(messages)
    msg = char(messages(i));
    l = length(msg);    
    msg_spl = mat2cell(msg,1,len42*ones(l/len42,1));
    msg_42 = ismember(msg_spl,rule42);
    msg_31 = ismember(msg_spl,rule31);
    if part == 1
        if msg_42(1) && msg_42(2) && msg_31(3) && width(msg_spl) == 3
            s = s+1;
        end
    elseif part == 2
        if any(msg_42) && any(msg_31) && (sum(msg_42) > sum(msg_31))
            f_42 = find(msg_42);
            if all(diff(f_42) == 1) && f_42(1) == 1 && length(f_42) > 1
                f_31 = find(msg_31);
                if (isempty(diff(f_31)) || all(diff(f_31) == 1)) && (f_31(1) == f_42(end)+1)
                    s = s+1;
                end
            end        
        end
    end
end
s
toc
function allowed = findCorrectMessages(all_rules)
    all_rules = cellstr(all_rules);  
    known_rules = string.empty;
    % split all
    for i=1:height(all_rules)
        if contains(all_rules{i},'|')
            rule1 = string(extractBefore(all_rules{i},'|'));
            rule2 = string(extractAfter(all_rules{i},'|'));
            all_rules{i} = cat(1,rule1,rule2);
        end
    end
%     find the rule that is "a" and replace everything    
    for i=1:height(all_rules)
        if all(strcmp(all_rules{i},'"a"')) || all(strcmp(all_rules{i},'"b"'))
            all_rules{i} = all_rules{i}(2);
            known_rules = [known_rules num2str(i-1)];
        end
    end
    while true
        for kr = known_rules
            rep = all_rules{str2double(kr)+1};
            for i=1:height(all_rules)
                all_known = true;
                all_rules_i = all_rules{i};
                if isempty(all_rules_i)
                    continue
                end
                new_rules = string.empty;
                for j=1:height(all_rules_i)
                    all_rules_ij = all_rules_i(j,:);
                    s = ismember(extract(all_rules_ij,digitsPattern),kr);
                    if sum(s)>0
                        for si=1:sum(s)
                            for k=1:height(rep)
                                for l=1:height(all_rules_ij)
                                    new_rules(end+1,:) = regexprep(all_rules_ij(l,:),'(?<!\d)('+kr+')(?!\d)',rep(k,:),1);
                                    if ~isempty(extract(new_rules(end,:),digitsPattern))
                                        all_known = all_known && false;
                                    end
                                end
                            end
                            nums = regexp(new_rules,'(\d*)','match');
                            if isempty(nums)
                                s = 0;
                            else
                                s = ismember([nums{:}],kr);
                            end
                            if sum(s) > 0
                                all_rules_ij = new_rules;
                                new_rules = string.empty;
                                all_known = true;
                            end
                        end
                    else
                        if isempty(all_rules_ij) || ~isempty(extract(all_rules_ij,digitsPattern))
                            all_known = all_known && false;
                        end
                        new_rules(end+1,:) = all_rules_ij;
                    end  
                end
                if ~isempty(new_rules) 
                    all_rules{i} = char(new_rules);
                end
                if all_known && ~isempty(new_rules)
                    known_rules = [known_rules num2str(i-1)];
                    all_rules{i} = char(string(arrayfun(@(rid) erase(all_rules{i}(rid,:),' '),(1:size(all_rules{i},1))','UniformOutput',false)));
                end
            end
            all_rules{str2double(kr)+1} = '';
            known_rules = unique(known_rules(known_rules ~= kr));
        end
        if (any(ismember(known_rules,"42"))  && any(ismember(known_rules,"31")))|| isempty(known_rules)
            allowed = all_rules;
            return
        end
    end
end