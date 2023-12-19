input = readlines('a19.txt');
workflows = input(1:find(input == '')-1);
workflow_names = workflows.extractBefore('{');
workflow_rules = workflows.extractBetween('{','}');
ratings = input(find(input == '')+1:end);
accepted_sum = 0;


for i=1:height(ratings)
    rating = ratings(i).extractBetween('{','}').split(',');
    t1 = rating.split('=');
    rat_dict = dictionary(char(t1(:,1)),t1(:,2).double);
    current_rules = workflow_rules(workflow_names == 'in').split(',');
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
        current_rules = workflow_rules(workflow_names == new_name).split(',');
    end
    if accepted
        accepted_sum = accepted_sum + sum(t1(:,2).double);
    end


end