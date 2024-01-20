input = char(readlines("a20.txt"));

loc = [0 0]; % r, c of start position

openB = find(input == '('); closeB = find(input == ')');
opt = find(input == '|');
depth = 0;

nloc = loc + gD(input(2));
G = graph(n2s(loc),n2s(nloc));
loc = nloc;

input = input(3:end);

[G, in, oloc, ~] = rec(G, input, loc, []);
plotMap(G);

function [G, in, oloc, loc_list] = rec(G, in, start_loc, loc_list)
    oloc = start_loc;
    while true
        while ~ismember(in(1),["|","(",")", "$"])
            nloc = oloc + gD(in(1));
            G = G.addedge(n2s(oloc),n2s(nloc));
            oloc = nloc;
            in = in(2:end);    
        end
        if ismember(in(1), "|")
            loc_list(end+1,:) = oloc;
            oloc = start_loc;
            in = in(2:end);
            continue
        end
        if in(1) == '('
            cur_loc_list = loc_list; % wrong
            [G, in, nloc, loc_list] = rec(G, in(2:end), oloc, []);
        end
        if in(1) == ')'
            loc_list(end+1,:) = oloc;
            in = in(2:end);
            return
        end
        if in(1) == "$"
            break
        end
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