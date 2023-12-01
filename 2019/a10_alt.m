map = char(strrep(strrep(readlines("input_10.txt"),'#','1'),'.','0'))-'0';
tic
ast_list = [];
for i=1:height(map)
    for j=1:width(map)
        if map(i,j) == 1
            ast_list(end+1,:) = [j i];
        end
    end
end
max_num_vis = 0;
max_pos = [];
for i = 1:height(ast_list)
    ast = ast_list(i,:);
    out = getAngleMat(width(map),height(map),ast);
    angle_list = unique(out(:));
    remain_ast = ast_list(~ismember(ast_list,ast,"rows"),:);
    % start searching in a circle clockwise with an angle. The angle starts at zero
    % degrees (12 o'clock)  
    num_vis = 0;
    for angle = angle_list'
        normal_vec = [sin(angle*pi/180) -cos(angle*pi/180)];
        b = @(x) ast+x*normal_vec;
        x_list = zeros(height(remain_ast),1);
        
        for j=1:height(remain_ast)
            rast = remain_ast(j,:);
            % x
            if abs(normal_vec(1)) <= 10^-10
                if ast(1) ~= rast(1)
                    continue
                end
                x_list(j) = (rast(2) - ast(2)) / normal_vec(2);
            end
            % y
            if abs(normal_vec(2)) <= 10^-10
                if ast(2) ~= rast(2)
                    continue
                end
                x_list(j) = (rast(1) - ast(1)) / normal_vec(1);
            end
            x1 = (rast(1)-ast(1))/normal_vec(1);
            x2 = (rast(2)-ast(2))/normal_vec(2);
            if abs(x1-x2) <= 10^-10
                x_list(j) = x1;
            end

        end
        x_list = min(x_list(x_list>0));
        if ~isempty(x_list)
            num_vis = num_vis + 1;
        end
    end
    if num_vis > max_num_vis
        max_num_vis = num_vis;
        max_pos = ast;
    end
end
max_num_vis
max_pos
%% Part 2
ast = max_pos;
out = getAngleMat(width(map),height(map),ast);
angle_list = unique(out(:));
remain_ast = ast_list(~ismember(ast_list,ast,"rows"),:);
remove_counter = 0;
% start searching in a circle clockwise with an angle. The angle starts at zero
% degrees (12 o'clock)
for angle = angle_list'
    normal_vec = [sin(angle*pi/180) -cos(angle*pi/180)];
    b = @(x) ast+x*normal_vec;
    x_list = zeros(height(remain_ast),1);
    rast_to_remove = zeros(height(remain_ast),2);
    for j=1:height(remain_ast)
        rast = remain_ast(j,:);
        % x
        if abs(normal_vec(1)) <= 10^-10
            if ast(1) ~= rast(1)
                continue
            end
            x_list(j) = (rast(2) - ast(2)) / normal_vec(2);
            rast_to_remove(j,:) = rast;
        end
        % y
        if abs(normal_vec(2)) <= 10^-10
            if ast(2) ~= rast(2)
                continue
            end
            x_list(j) = (rast(1) - ast(1)) / normal_vec(1);
            rast_to_remove(j,:) = rast;
        end
        x1 = (rast(1)-ast(1))/normal_vec(1);
        x2 = (rast(2)-ast(2))/normal_vec(2);
        if abs(x1-x2) <= 10^-10
            x_list(j) = x1;
            rast_to_remove(j,:) = rast;
        end

    end
    id = find(x_list>0);
    x_list = x_list(id);
    rast_to_remove = rast_to_remove(id,:);
    if numel(id)>1
        [~,id2] = min(x_list);
        rast_to_remove = rast_to_remove(id2,:);
    end
    if ~isempty(rast_to_remove)
        remain_ast = remain_ast(~ismember(remain_ast,rast_to_remove,"rows"),:);
        remove_counter = remove_counter + 1;
    end
    if remove_counter == 200
        rast_to_remove
        res = (rast_to_remove(1)-1) * 100 + rast_to_remove(2)-1
        break
    end
end


toc
function out = getAngleMat(hx,hy,ast)
    x = ast(1);
    y = ast(2);
    out = zeros(hx,hy);    
    % WN
    if y > 1
        if x > 1
            for i=(-x+1):-1
                for j=(-y+1):-1
                    out(y+j,x+i) = 270 + atand(j/i);
                end
            end
        end
    end
    % EN
    if y > 1
        if x < hx
            for i=1:(hx-x)
                for j=(-y+1):-1
                    out(y+j,x+i) = atand(-i/j);
                end
            end
        end
    end
    % W
    if x > 1
        out(y,1:(x-1)) = 270;
    end
    % ES
    if y < hy
        if x < hx
            for i=1:(hx-x)
                for j=1:(hy-y)
                    out(y+j,x+i) = 90 + atand(j/i);
                end
            end
        end
    end
    % E
    if x<hx
        out(y,(x+1):end) = 90;
    end
    % WS
    if y < hy
        if x > 1
            for i=(-x+1):-1
                for j=1:(hy-y)
                    out(y+j,x+i) = 180 + atand(-i/j);
                end
            end
        end
    end
    % S
    if y < hy
        out((y+1):end,x) = 180;
    end
end