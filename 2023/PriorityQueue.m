classdef PriorityQueue < handle
    % PriorityQueue is a simple implementation of a priority queue.
    
    properties
        items = {}; % Stores the items in the queue
    end
    
    methods
        function obj = push(obj, item, priority)
            % Pushes an item onto the queue with the given priority
            obj.items{end + 1} = struct('item', item, 'priority', priority);
        end
        
        function item = pop(obj)
            % Pops the item with the highest priority from the queue
            priorities = [obj.items{:}];
            priorities = [priorities.priority];
            [~, idx] = min(priorities);
            item = obj.items{idx}.item;
            obj.items(idx) = [];
        end
        
        function result = isEmpty(obj)
            % Returns true if the queue is empty, false otherwise
            result = isempty(obj.items);
        end
        
        function obj = updateKey(obj, ch_item, newPrio)
            items = [obj.items{:}];
            items1 = reshape([items.item],3,[])';
            idx = all(items1(:,1:2) == ch_item(1:2),2);
            obj.items{idx}.item = ch_item;
            obj.items{idx}.priority = newPrio;
        end
        
        function its = getItems(obj)
            its = [obj.items{:}];
            if ~isempty(its)
                its = reshape([its.item],3,[])';
            end
        end
    end
end