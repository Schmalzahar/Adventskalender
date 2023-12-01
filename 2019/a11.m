code = readmatrix("input_11.txt");
pos = [0 0];
i = 1;
rel_base = 0;
out = [0 i rel_base];
direction = 1; %1:north, 2:east, 3:south, 4: west
traveled_pos = [];
part = 2;
if part == 1
    inp1 = 0;
elseif part == 2
    inp1 = 1;
end
while true
    if isempty(traveled_pos)
        [out, code] = run_intcode(code,inp1,0,out(2),out(3));
    else
        members = ismember(traveled_pos(:,1:2),pos,"rows");
        if any(members)
            id = find(members);
            [out, code] = run_intcode(code,0,traveled_pos(id,3),out(2),out(3));
            traveled_pos(id,:) = [];
        else
            [out, code] = run_intcode(code,0,0,out(2),out(3));
        end
    end
    % move accordingly
    traveled_pos(end+1,:) = [pos out(1)];
    if numel(out) < 3
        break
    end
    [out, code] = run_intcode(code,0,0,out(2),out(3));
    dir = out(1);
    if dir==0
        direction = mod(direction+2,4)+1; % turn left
    elseif dir == 1
        direction = mod(direction,4)+1; % turn right
    end
    switch direction
        case 1
            pos = [pos(1) pos(2)+1];
        case 2
            pos = [pos(1)+1 pos(2)];
        case 3
            pos = [pos(1) pos(2)-1];
        case 4
            pos = [pos(1)-1 pos(2)];
    end    
end
res = height(traveled_pos)
% Plot
p = traveled_pos(traveled_pos(:,3)==1,:);
x = p(:,1);
y = p(:,2);
z = p(:,3);
scatter3(x,y,z)