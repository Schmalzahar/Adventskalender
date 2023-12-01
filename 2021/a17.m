%% Day 17
close all
input = readmatrix("input_a17.txt","OutputType","string");
target_x = str2double(strsplit(extractAfter(input(1),'x='),'..'));
target_y = str2double(strsplit(extractAfter(input(2),'y='),'..'));
xa = target_x(1);
xb = target_x(2);
ya = target_y(1);
yb = target_y(2);
%% Some math
% The start position is (0,0). If x(n) is the x position after n steps and
% y(n) the y position after n steps, then x(0) = y(0) = 0
% x(n) = 0 + u0 + (u0 - 1) + (u0 - 2) + ... + (u0 - n + 1) =
% n*u0-sum(k)_0^n-1
% y(n) = 0 + v0 + (v0 - 1) + (v0 - 2) + ... + (v0 - n + 1) =
% n*v0-sum(k)_0^n-1
% With Gauß: sum(k)_0^n-1 = n*(n-1)/2
% The maximum of y(n) occurs at n=v0 (take the derivative of y and set to
% zero). The maximum value is y(n=v0) = v0(v0+1)/2









%% dump
%maxHeight = target_y1(1)*(target_y1(1)+1)/2;
tic
[number,vv, hmax] = findAll(xa:xb, ya:yb);
toc
scatter3(vv(:,1),vv(:,2),vv(:,3),4,vv(:,3));

function [vl,aV, hmax] = findAll(tx, ty)
    aV = [];
    c = 0;
    mc = 100;
    rx = [0 max(tx)];
    ry = [-max(abs(ty)) max(abs(ty))];
    while true
        while true
            vx = randi(rx);
            vy = randi(ry);
            v = [vx vy];
            if ~isempty(aV) && ismember(v, aV(:,1:2),"rows")
                c = c + 1;
                if c > mc; return; end
                continue
            else
                [in, omh] = fly(v,tx,ty);
            end
            if in; break; end
        end        
        aV = cat(1,aV,[v omh]);
        while true
            out = sw(aV,tx,ty);
            if isempty(out)                
                break
            end       
            % new aV 
            aV = unique(cat(1,aV,out),'rows');          
            vl = height(aV);
            hmax = max(aV(:,3));
        end
    end
end

function out = sw(v,tx,ty)
    vs = fs(v(:,1:2));
    isin = false(height(vs),1);
    htemp = [];
    for i=1:height(vs)        
        [isin(i), temp] = fly(vs(i,:),tx,ty);
        if isin(i)
            htemp(end+1,1) = temp;
        end        
    end
    vout = vs(isin,:);
    out = [vout htemp];
end

function vs = fs(v)
    vs = [];
    vs = cat(1,vs, [v(:,1)+1 v(:,2)]);
    vs = cat(1,vs, [v(:,1)-1 v(:,2)]);
    vs = cat(1,vs, [v(:,1) v(:,2)+1]);
    vs = cat(1,vs, [v(:,1) v(:,2)-1]);
    % remove those in v
    vs = unique(vs,'rows');
    vs = vs(~ismember(vs,v,'rows'),:);
end

% function [in, max_height] = fly(v, tx, ty)
%     max_height = -inf;
%     in = false;
%     pos = [0, 0];
%     while true
%         if pos(2) > max_height
%             max_height = pos(2);
%         end
%         pos(1) = pos(1)+ v(1);
%         pos(2) = pos(2) + v(2);        
%         if v(1) ~= 0
%             if v(1) > 0 && pos(1) > max(tx)
%                 break
%             elseif v(1) < 0 && pos(1) < min(tx)
%                 break
%             end
%             v(1) = v(1) - sign(v(1));
%         elseif v(1) == 0 && all(pos(2)<ty)
%             break
%         end
%         v(2) = v(2) - 1;
%         if any(pos(1) == tx) && any(pos(2) == ty)
%             in = true;
%             break
%         end        
%     end  
% end
function [in, max_height] = fly(v, tx, ty)
    max_height = -inf;
    in = false;
    pos = [0,0];
    x_pos = @(n) n.*v(1) - (n.*sign(v(1))).*(n.*sign(v(1))+1)/2;
    y_pos = @(n) n.*v(2) - (n).*(n+1)/2;
end
