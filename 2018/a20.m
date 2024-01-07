input = char(readlines("a20.txt"));

loc = [0 0]; % r, c of start position

openB = find(input == '('); closeB = find(input == ')');
opt = find(input == '|');
depth = 0;

nloc = loc + gD(input(2));
G = graph(n2s(loc),n2s(nloc));
loc = nloc;

reg = input(3:(openB(1)-1));
input = input(openB(1):end);
closeB = closeB - openB(1)+1;
opt = opt - openB(1)+1;
openB = openB - openB(1)+1;
[G, loc] = addDoors(G, reg, loc);
% now we have a bracket, find all contents in this bracket
t1 = zeros(max(closeB),1);
t2 = t1; t2(openB) = 1; t2 = cumsum(t2);
t3 = t1; t3(closeB) = -1; t3 = cumsum(t3);
depths = t2 + t3;




% while true
%     if openB(1) == 1
%         depth = depth + 1;
%         % next is either another openB, a closeB or an opt;
%         if openB(2) < closeB(1) && openB(2) < opt(1)
% 
%         elseif closeB(1) < openB(2) && closeB(1) < opt(1)
% 
%         else
%             % first option
%             i1 = input(openB(1)+1:opt(1)-1);
%             [G, nloc1] = addDoors(G, i1, loc);
%             % rem
%             input = input(opt(1)+1:end);
%             closeB = closeB - opt(1); closeB(closeB<1) = [];
%             openB = openB - opt(1); openB(openB<1) = [];
%             opt = opt - opt(1); opt(opt<1) = [];
%         end
%     else
%         reg = input(1:(openB(1)-1));
%         input = input(openB(1):end);
%         closeB = closeB - openB(1)+1;
%         opt = opt - openB(1)+1;
%         openB = openB - openB(1)+1;   
%     end
% 
% 
%     if reg(1) == '^'
%         nloc = loc + gD(reg(2));
%         G = graph(n2s(loc),n2s(nloc));
%         loc = nloc;
%         reg = reg(3:end);        
%     end
%     [G, loc] = addDoors(G, reg, loc);
% 
% end

% function [G, in, oloc] = rec(G, in, loc)
%     oloc = loc;
%     while ~ismember(in(1),["|","(",")", "$"])
%         nloc = oloc + gD(in(1));
%         G = G.addedge(n2s(oloc),n2s(nloc));
%         oloc = nloc;
%         in = in(2:end);    
%     end
%     if ismember(in(1), ["|",")"])
%         [G, in, n]
%         % in = in(2:end);
%         return
%     end
%     if in(1) == '('
%         % option 1
%         [G, in, nloc] = rec(G, in(2:end), oloc);
%         if in(1) == '|'
%             [G, in, nnloc] = rec(G, in(2:end), oloc);
%         end
%     end
% end

function [G, loc] = addDoors(G, reg, loc)
    % just adds doors, no choices.
    for i=1:length(reg)
        nloc = loc + gD(reg(i));
        G = G.addedge(n2s(loc),n2s(nloc));
        loc = nloc;
    end
end

function dir =  gD(orientation)
    switch orientation
        case 'E'
            dir = [0 1];
        case 'W'
            dir = [0 -1];
        case 'N'
            dir = [-1 0];
        case 'S'
            dir = [1 0];
    end
end 

function out = n2s(loc)
    out = sprintf('(%d,%d)',loc(1),loc(2));
end