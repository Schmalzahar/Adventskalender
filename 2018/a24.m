input = readlines("a24.txt"); spl = find(input == "");
immune_system = {};
infection = {};
j = 1;
while true
    l = input(j);
    if contains(l,"Immune")
        type = "Immune";
    elseif contains(l, "Infection")
        type = "Infection";
    end
    if contains(l,"unit")
        while ~contains(l,"initiative")
            l = append(l,input(j+1));
            j = j + 1;               
        end
        sys = reindeer(type);
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

% target selection
im_eff = cellfun(@(x) x.geteffPower,immune_system);
inf_eff = cellfun(@(x) x.geteffPower,infection);
target_order = [];
max_eff = 0;



infection{2}.attack(immune_system{2})




