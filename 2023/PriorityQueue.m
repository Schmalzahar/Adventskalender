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
    end
end