classdef PriorityQueue < handle
    % PriorityQueue is a simple implementation of a priority queue.
    
    properties
        items = []; % Stores the items in the queue
        priorities = [];
    end
    
    methods
        % function obj = PriorityQueue(fin)
        %     obj.fin = fin;
        % end

        function obj = push(obj, item, priority)
            % Pushes an item onto the queue with the given priority
            % obj.items are already sorted by obj.priorities.
            % you can also just sort, but this here exploits the fact that
            % it is already sorted
            if isempty(obj.priorities)
                obj.priorities = priority;
                obj.items = item;   
                return
            % elseif priority >= obj.priorities(end)
            %     obj.priorities(end+1,:) = priority;
            %     obj.items(end+1,:) = item;                
            % elseif priority <= obj.priorities(1)
            %     obj.priorities = [priority; obj.priorities];
            %     obj.items = [item; obj.items];                
            % else
            %     id1 = find(obj.priorities < priority,1,'last');
            %     obj.priorities = [obj.priorities(1:id1,:); priority; obj.priorities(id1+1:end,:)];
            %     obj.items = [obj.items(1:id1,:); item; obj.items(id1+1:end,:)];               
            end
            id1 = find(obj.priorities < priority,1,'last');
            if isempty(id1)
                obj.priorities = [priority; obj.priorities];
                obj.items = [item; obj.items];  
            else
                obj.priorities = [obj.priorities(1:id1,:); priority; obj.priorities(id1+1:end,:)];
                obj.items = [obj.items(1:id1,:); item; obj.items(id1+1:end,:)]; 
            end
        end
        
        function [item, minPrio] = pop(obj)
            % Pops the item with the highest priority from the queue
            item = obj.items(1,:); obj.items(1,:) = [];
            minPrio = obj.priorities(1,:); obj.priorities(1,:) = [];
        end
        
        function result = isEmpty(obj)
            % Returns true if the queue is empty, false otherwise
            result = isempty(obj.items);
        end
       
        
        function its = getItems(obj)
            its = [obj.items{:}];
            if ~isempty(its)
                its = reshape([its.item],3,[])';
            end
        end
    end
end