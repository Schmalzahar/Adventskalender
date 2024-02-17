classdef reindeer
    %reindeer Immune system and infection class

    properties
        type
        hit_points
        count
        weakness
        immunity
        dmg_type
        dmg
        initiative
        toattack
        todefend
        id
    end

    methods
        function obj = reindeer(type)
            %reindeer Construct an instance of this class
            obj.type = type;
            % obj.id = randi(10e10);
        end

        function out = geteffPower(obj)
            out = obj.count * obj.dmg;
        end

        function dmg_dealt = calcDmg(obj, toAttack)
            if obj.type == toAttack.type
                dmg_dealt = -1;
                return
            end
            weak = toAttack.weakness;
            imun = toAttack.immunity;
            if ~isempty(imun) && ismember(obj.dmg_type, imun)
                dmg_dealt = 0;
            elseif ~isempty(weak) && ismember(obj.dmg_type, weak)
                dmg_dealt = 2 * obj.geteffPower;
            else
                dmg_dealt = obj.geteffPower;
            end
        end

        function remain = dealDmg(obj, toAttack)
            dmg_dealt = obj.calcDmg(toAttack);
            remain = max(0,ceil((toAttack.count * toAttack.hit_points - dmg_dealt) / toAttack.hit_points));
        end

        function obj = clear(obj)
            obj.toattack = [];
            obj.todefend = [];
        end
    end
end