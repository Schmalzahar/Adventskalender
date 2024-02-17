input = readlines("a24.txt"); spl = find(input == "");
immune_system = {}; imn_cnt = 0;
infection = {}; inf_cnt = 0;
j = 1;
while true
    l = input(j);
    if contains(l,"Immune")
        type = "Immune"; imn_cnt = imn_cnt + 1;
        num = imn_cnt;
    elseif contains(l, "Infection")
        type = "Infection"; inf_cnt = inf_cnt + 1;
        num = inf_cnt;
    end
    if contains(l,"unit")
        while ~contains(l,"initiative")
            l = append(l,input(j+1));
            j = j + 1;               
        end
        sys = reindeer(type);
        sys.id = strcat(type,num2str(num)); num = num + 1;
        sys.count = l.extractBefore("units").extract(digitsPattern).double;
        sys.hit_points = l.extractBetween("with","hit").extract(digitsPattern).double;
        if contains(l,"(")
            weakimmune = l.extractBetween("(",")");
            if contains(weakimmune,"weak")
                weak = weakimmune.extractAfter("weak to ");
                if contains(weak,";")
                    weak = weak.extractBefore(";");
                end
                sys.weakness = strtrim(weak.split(','));
            end
            if contains(weakimmune,"immune")
                immune = weakimmune.extractAfter("immune to ");
                if contains(immune,";")
                    immune = immune.extractBefore(";");
                end
                sys.immunity = strtrim(immune.split(','));
            end
        end
        sys.dmg = l.extractBetween("attack","damage").extract(digitsPattern).double;
        temp = l.extractBefore("damage").split(" ");
        sys.dmg_type = temp(end-1);
        sys.initiative = l.extractAfter("initiative").extract(digitsPattern).double;
        if type == "Immune"
            immune_system{end+1} = sys;
        else
            infection{end+1} = sys;
        end         
    end
    j = j + 1;
    if j > height(input)
        break
    end
end
system = [immune_system{:} infection{:}];


%% target selection
while true
    % remove empty groups from combat    
    system_eff = arrayfun(@(x) x.geteffPower,system);
    system = system(system_eff > 0); system_eff(system_eff==0) = [];
    % clear previous toattack and todefend
    system = arrayfun(@(x) x.clear, system);
    % are we done?
    if size(system,2) == 2
        test = 1;
    end
    if all(system(1).type == [system.type])
        sum([system.count])
        break
    end
    temp_atk_system = system; temp_def_system = system;
    temp_atk_system_eff = system_eff; temp_def_system_eff = system_eff;
    while ~isempty(temp_atk_system_eff)    
        % choose attacker
        max_sys_eff = max(temp_atk_system_eff);
        if sum(max_sys_eff == temp_atk_system_eff) > 1
            t1 = temp_atk_system(max_sys_eff == temp_atk_system_eff);
            max_ini = max([t1.initiative]);
            attacker = t1([t1.initiative] == max_ini);
            temp_atk_system = temp_atk_system([temp_atk_system.id] ~= attacker.id);
            temp_atk_system_eff = arrayfun(@(x) x.geteffPower,temp_atk_system);
        else
            attacker = temp_atk_system(temp_atk_system_eff == max_sys_eff);
            temp_atk_system = temp_atk_system(temp_atk_system_eff ~= max_sys_eff);
            % temp_atk_system_eff = arrayfun(@(x) x.geteffPower,temp_atk_system);
            temp_atk_system_eff = temp_atk_system_eff(temp_atk_system_eff ~= max_sys_eff);
        end    
        % choose defender
        dmg = arrayfun(@(x) attacker.calcDmg(x),temp_def_system);
        max_dmg = max(dmg);
        if max_dmg <= 0
            continue
        end
        if sum(max_dmg == dmg) > 1
            % go by eff power
            max_def_eff = max(temp_def_system_eff(max_dmg == dmg));
            t1 = temp_def_system(max_dmg == dmg);
            t1_eff = temp_def_system_eff(max_dmg == dmg);
            if sum(max_def_eff == t1_eff) > 1
                % go by initiative
                t2 = t1(max_def_eff == t1_eff);
                max_ini =  max([t2.initiative]);
                defender = t2([t2.initiative] == max_ini);
                temp_def_system = temp_def_system([temp_def_system.id] ~= defender.id);
                temp_def_system_eff = arrayfun(@(x) x.geteffPower,temp_def_system);
            else            
                defender = t1(t1_eff == max_def_eff);
                temp_def_system = temp_def_system([temp_def_system.id] ~= defender.id);
                temp_def_system_eff = arrayfun(@(x) x.geteffPower,temp_def_system);
            end
        else
            defender = temp_def_system(dmg == max_dmg);
            temp_def_system = temp_def_system(dmg ~= max_dmg);
            temp_def_system_eff = arrayfun(@(x) x.geteffPower,temp_def_system);
        end

        % set attacker and defender to system
        system([system.id] == attacker.id).toattack = defender.id;
        system([system.id] == defender.id).todefend = attacker.id;
    end
    
    %% attack phase
    system_init = [system.initiative];
    system_ids = [system.id];
    [~,I] = sort(system_init,'descend');
    for i=1:numel(I)
        attacker = system(I(i));
        if ~isempty(attacker.toattack)
            defender = system(attacker.toattack == system_ids);
            system(attacker.toattack == system_ids).count = attacker.dealDmg(defender);
        end
    end
    for i=1:numel(system)
        fprintf(system(i).id+": "+system(i).count+"\n")
    end
    fprintf('-----------\n')
end