input = readlines('a20.txt').split(' -> ');
bc = input(input(:,1) == 'broadcaster',2);
flipflop = input(contains(input(:,1),'%'),:);
conjunction = input(contains(input(:,1),'&'),:);
t = char(flipflop(:,1));
t1 = char(conjunction(:,1));
flipflop(:,1) = string(t(:,2:end));
flipflop = dictionary(flipflop(:,1), flipflop(:,2));
conjunction(:,1) = string(t1(:,2:end));
conjunction = dictionary(conjunction(:,1), conjunction(:,2));

modules = dictionary(flipflop.keys, zeros(height(flipflop.keys),1));

sendPulse(0,flipflop, conjunction, modules, [], bc)

% button sends low pulse to broadcaster. Broadcaster sends this pulse to
% every module in bc

function queue = sendPulse(pulse, flipflop, conjunction, modules, queue, in)
    % send pulse to in
    in = string(in);
    in_spl = strtrim(in.split(','));
    if isempty(queue)
        for i=1:height(in_spl)
            lhs = in_spl(i);
            if isKey(flipflop, lhs) && ~pulse
                queue = [queue; sprintf("out = sendPulse(%d, flipflop, conjunction, modules, queue, '%s')",pulse, lhs) ];
                % if modules(lhs) == 0
                %     flipflop{lhs}(2) = "1";
                %     out = sendPulse(1, flipflop, conjunction, flipflop{lhs}(1));
                % else
                %     flipflop{lhs}(2) = "0";
                %     out = sendPulse(0, flipflop, conjunction, flipflop{lhs}(1));
                % end               
            elseif isKey(conjunction, lhs)
    
            end
        end
    else
        queue(1,:) = [];
        if isKey(flipflop, in) && ~pulse
            if modules(in) == 0
                modules(in) = 1;                
            else
                modules(in) = 0;
            end            
            pulse = 1;                
            queue(end+1,:) = sprintf("out = sendPulse(%d, flipflop, conjunction, modules, queue, '%s')",pulse, flipflop(in));
        elseif isKey(conjunction, in)
            test = 1
        end
    end
    % go through queue
    for j=1:height(queue)
        q = queue(j,:);
        eval(q)
    end


end