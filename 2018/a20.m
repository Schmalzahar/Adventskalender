input = char(readlines("a20.txt"));

loc = [0 0]; % r, c of start position

openB = find(input == '('); closeB = find(input == ')');
opt = find(input == '|');
depth = 0;

nloc = loc + gD(input(2));
G = graph(n2s(loc),n2s(nloc));
loc = nloc;

input = input(3:end);

[G, in, oloc] = rec(G, input, loc);
plotMap(G);

% reg = input(1:(openB(1)-1));
% input = input(openB(1):end);
% closeB = closeB - openB(1)+1;
% opt = opt - openB(1)+1;
% openB = openB - openB(1)+1;
% [G, loc] = addDoors(G, reg, loc);
% % now we have a bracket, find all contents in this bracket
% t1 = zeros(max(closeB),1);
% t2 = t1; t2(openB) = 1; t2 = cumsum(t2);
% t3 = t1; t3(closeB) = -1; t3 = cumsum(t3);
% depths = t2 + t3;
% 
% 
% loc_queue = loc;
% depth_end = find(depths == 0,1);
% reg = input(1:depth_end);
% opts = opt(opt<=depth_end);
% branches = {};
% for i=1:length(opts)
%     branches{i} = reg(2:opts(i)-1);
% end
% branches{i+1} = reg(opts(end)+1:end-1);
% 
% new_locs = [];
% for i=1:size(loc_queue,1)
%     locs = loc_queue(i,:);
%     for j=1:size(branches,2)
%         [G, loc] = addDoors(G, branches{j}, locs);
%         if isempty(new_locs) || ~ismember(loc, new_locs,"rows")
%             new_locs(end+1,:) = loc;
%         end
%     end
% end
% loc_queue = new_locs;





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

function [G, in, oloc] = rec(G, in, loc)
    oloc = loc;
    while ~ismember(in(1),["|","(",")", "$"])
        nloc = oloc + gD(in(1));
        G = G.addedge(n2s(oloc),n2s(nloc));
        oloc = nloc;
        in = in(2:end);    
    end
    if ismember(in(1), "|")
        openB = in == '('; closeB = find(in == ')');
        opt = find(in == '|');
        t1 = zeros(max(closeB),1);
        t2 = t1; t2(openB) = 1; t2 = cumsum(t2);
        t3 = t1; t3(closeB) = -1; t3 = cumsum(t3);
        depths = t2 + t3;
        curr_dep = depths(1);
        next_stop = find(depths == curr_dep-1,1)+1;
        % in = in(next_stop:end);
        [G, ~, noloc] = rec(G, in(2:end), loc); % next option
        [G, nin, oloc] = rec(G, in(next_stop:end), loc); % after the branch
        [G, nin, oloc] = rec(G, in(next_stop:end), noloc); % after the branch
        return
    end
    if in(1) == '('
        % option 1
        [G, in, nloc] = rec(G, in(2:end), oloc);
        return
        % if in(1) == '|'
        %     [G, in, nnloc] = rec(G, in(2:end), oloc);
        % end
    end
    if in(1) == ")"
        oloc = loc;
        return
    end
end

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

function plotMap(G)
    nodes = string(G.Nodes.Variables);
    edges = string(G.Edges.EndNodes);
    r = extractBetween(nodes,"(",",").double;
    re = extractBetween(edges,"(",",").double;
    c = extractBetween(nodes,",",")").double;
    ce = extractBetween(edges,",",")").double;
    points = [r c];
    map = zeros([2*(max(r)-min(r)+1)+1, 2*(max(c)-min(c)+1)+1]);
    cmap = char(map);
    ro = 2*(1-min(r)); co = 2*(1-min(c));
    cmap(2:2:end,2:2:end) = '.';    
    cmap(1:2:end,1:2:end) = '#';
    cmap(ro+0,co+0) = 'X';
    for i=1:height(re)
        n1 = [re(i,1) ce(i,1)];
        n2 = [re(i,2) ce(i,2)];
        if n1(1) == n2(1)
            cmap(ro+2*n1(1),co+n1(2)+n2(2)) = '|';
        else
            cmap(ro+n1(1)+n2(1),co+2*n1(2)) = '-';
        end
    end
    cmap(cmap == 0) = '#'
end