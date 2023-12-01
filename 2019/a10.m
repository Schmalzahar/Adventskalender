map = char(strrep(strrep(readlines("input_10.txt"),'#','1'),'.','0'))-'0';
max_other_astro = 0;
divisor_map = cell(max(size(map))+1,1);
tic
best = [];
for i=1:height(map)
    for j=1:width(map)
        a = [j;i];
        other_astro = 0;
        if map(i,j) == 1
            test = 1;
            for k=1:height(map)                
                for l=1:width(map)
                    if i == k && j == l
                        continue
                    end
                    if map(k,l) ~= 1
                        continue
                    end
                    test = 2;
                    
                    b = [l;k];
                    vec_ab = b-a;
                    if isempty(divisor_map{abs(vec_ab(1))+1})
                        divisor_map{abs(vec_ab(1))+1} = divisors(vec_ab(1));
                    end
                    if isempty(divisor_map{abs(vec_ab(2))+1})
                        divisor_map{abs(vec_ab(2))+1} = divisors(vec_ab(2));
                    end
                    diva = divisor_map{abs(vec_ab(1))+1};
                    divb = divisor_map{abs(vec_ab(2))+1};
                    blocked = false;
                    if any(vec_ab == 0)
                        len = norm(vec_ab);
                        nvec_ab = vec_ab / len;
                        for m=1:len-1
                            if map(i+m*vec_ab(2)/len,j+m*vec_ab(1)/len) == 1
                                blocked = true;
                                break
                            end
                        end
                    else
                        if ~any(abs(vec_ab) == 1)
                            common_divs = diva(ismember(diva,divb));
                            for m=1:numel(common_divs)-1
                                n = 1;
                                while true
                                    stepsize = common_divs(end-m+1);
                                    stepa = vec_ab(2)/stepsize;
                                    if stepa > 0 && i+n*stepa >= k
                                        break
                                    elseif stepa < 0 && i+n*stepa <= k
                                        break
                                    end
                                    stepb = vec_ab(1)/stepsize;
                                    if stepb > 0 && j+n*stepb >= l
                                        break
                                    elseif stepb < 0 && j+n*stepb <= l
                                        break
                                    end                                    
                                    if map(i+n*stepa,j+n*stepb) == 1
                                        blocked = true;
                                        break
                                    end                                
                                    n = n+1;
                                end
                            end
                        end
                    end
                    if ~blocked
                        other_astro = other_astro + 1;
                    end
                end
            end
        end
        if other_astro > max_other_astro
            max_other_astro = other_astro;
            best = a;
        end
    end
end
max_other_astro
%% Part 2
ast = best';
out = getAngleMat(width(map),height(map),ast);
angle_list = unique(out(:));
ast_list = [];
for i=1:height(map)
    for j=1:width(map)
        if map(i,j) == 1
            ast_list(end+1,:) = [j i];
        end
    end
end
remain_ast = ast_list(~ismember(ast_list,ast,"rows"),:);
remove_counter = 0;
% start searching in a circle clockwise with an angle. The angle starts at zero
% degrees (12 o'clock)
i = 1;
while true
    angle = angle_list(i);
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
        res = (rast_to_remove(1)-1) * 100 + rast_to_remove(2)-1
        break
    end
    i = i+1;
    if i > numel(angle_list)
        i = 1;
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