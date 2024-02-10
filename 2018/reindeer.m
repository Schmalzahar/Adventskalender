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
    end

    methods
        function obj = reindeer(type)
            %reindeer Construct an instance of this class
            obj.type = type;
        end

        function out = geteffPower(obj)
            out = obj.count * obj.dmg;
        end

        function test = attack(obj, toAttack)
            test = 1;
            weak = toAttack.weakness;
            imun = toAttack.immunity;
            if ~isempty(imun) && ismember(obj.dmg_type, imun)
                dmg_dealt = 0;
            elseif ~isempty(weak) && ismember(obj.dmg_type, weak)
                dmg_dealt = 2 * obj.geteffPower;
            else
                dmg_dealt = obj.geteffPower;
            end
            remain = max(0,ceil((toAttack.count * toAttack.hit_points - dmg_dealt) / toAttack.hit_points));

        end
    end
end