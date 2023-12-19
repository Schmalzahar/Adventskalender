input = readlines('a19.txt');
workflows = input(1:find(input == '')-1);
workflow_names = workflows.extractBefore('{');
workflow_rules = workflows.extractBetween('{','}');
workflow_dict = dictionary(workflow_names, workflow_rules);
ratings = input(find(input == '')+1:end);
accepted_sum = 0;

for i=1:height(ratings)
    rating = ratings(i).extractBetween('{','}').split(',');
    t1 = rating.split('=');
    rat_dict = dictionary(char(t1(:,1)),t1(:,2).double);
    current_rules = workflow_dict('in').split(',');
    done = 0;
    while ~done
        for j=1:height(current_rules)
            rule = char(current_rules(j));
            rule_req = current_rules(j).extractBefore(':');    
            if ismissing(rule_req)
                if rule(1) == 'A'
                    accepted = true;
                    done = 1;
                elseif rule(1) == 'R'
                    accepted = false;
                    done = 1;
                else
                    new_name = current_rules(j);
                    break
                end
            elseif eval(strrep(char(rule_req),rule(1),num2str(rat_dict(rule(1)))))
                new_name = current_rules(j).extractAfter(':');
                break
            end
        end
        if new_name == 'A'
            accepted = true;
            break
        elseif new_name == 'R'
            accepted = false;
            break
        end
        current_rules = workflow_dict(new_name).split(',');
    end
    if accepted
        accepted_sum = accepted_sum + sum(t1(:,2).double);
    end
end
% accepted_sum
%%
lims = [1,4000;1,4000;1,4000;1,4000];
format long
part2('in', workflow_dict, lims)
function out = part2(name, d, lims)
    persistent cache
    if name == 'A'
        cache(end+1) = prod(diff(lims,1,2)+1);
        return
    elseif name == 'R'
        return
    end
    if ismember(name,keys(d))        
        rule_str = d(name);
    else    
        rule_str = name;
    end
    rtype = ["x",'m','a','s'];
    rule_req = rule_str.extractBefore(':');
    fulfilled_opt = rule_str.extractBetween(':',',');
    not_fulfilled_opt = rule_str.extractAfter(',');
    dels = ['<','>'];
    type = ismember(dels,char(rule_req));
    spl = strsplit(rule_req,dels(type));
    I = find(spl(1) == rtype);
    fulfilled = lims;
    not_fulfilled = lims;
    if type(1)        
        fulfilled(I,:) = [lims(I,1) spl(2).double-1];
        not_fulfilled(I,:) = [spl(2).double lims(I,end)];            
    else
        fulfilled(I,:) = [spl(2).double+1 lims(I,end)];        
        not_fulfilled(I,:) = [lims(I,1) spl(2).double];
    end
    part2(fulfilled_opt(1), d, fulfilled);
    part2(not_fulfilled_opt, d, not_fulfilled);    
    out = sum(cache);
end