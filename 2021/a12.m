%% Day 12
input = readmatrix("input_a12.txt","OutputType","string");
% find the number of paths that visit small caves at most once
% any path must start at start and end at end. Small caves can only be
% visited once, large cave can be visited any number of times.
% Part 2: a single small cave can be visited at most twice and the
% remaining small caves at most once (not start/end)
names = ["start" "end"];
lowernames = string.empty;
for i=1:size(input,1)
    line = input(i);
    names_in_line = strsplit(line,'-');
    for name = names_in_line
        name_contained = ismember(name,names);
        if ~name_contained
            names = string({names{:},name});
            if ~isupper(name)
                lowernames = string({lowernames{:},name});
            end
        end
    end
end
% Now that we have the names, generate the graph from the input
s = double.empty;
t = double.empty;
for i=1:size(input,1)
    line = input(i);
    names_in_line = strsplit(line,'-');
    n1 = names_in_line{1};
    n2 = names_in_line{2};
    if strcmp(n2,"start")
        temp = n2;
        n2 = n1;
        n1 = temp;
    elseif strcmp(n1,"end")
        temp = n2;
        n2 = n1;
        n1 = temp;
    end
    n1up = isupper(n1);
    n2up = isupper(n2);

    s(end+1) = find(ismember(names,names_in_line{1}));
    t(end+1) = find(ismember(names,names_in_line{2}));
    t(end+1) = find(ismember(names,names_in_line{1}));
    s(end+1) = find(ismember(names,names_in_line{2}));
end

G = graph(s,t,[],names);

tic
paths = visit(G,"start",["start"],string.empty,true,lowernames);
disp("Result 1: " +size(paths,1))
toc
function paths = visit(G, node, previous_nodes, paths, twice,lowernames)
    for neighbor = neighbors(G,node)'
        % dont go back to previous nodes, upper case is allowed
        % if twice=true, allow one lowercase in previous
        previous_nodes_check = rmupper(previous_nodes);
        if twice
            nothing_removed = rmlower(neighbor,previous_nodes_check,lowernames);
            if ~nothing_removed
                paths = visit(G,neighbor,[previous_nodes, neighbor], paths, false,lowernames);
                continue
            end
        end
        if any(ismember(previous_nodes_check,neighbor))  
            continue
        elseif strcmp(neighbor, "end")
            paths(end+1,1) = strjoin([previous_nodes, neighbor],',');
            continue
        end
        paths = visit(G,neighbor,[previous_nodes, neighbor], paths, twice,lowernames);
    end
end

function removed = rmupper(previous)
    % remove all uppercase
    upperidx = isupper(previous);
    if all(~upperidx)
        removed = previous;
    else
        removed = previous(~upperidx);
    end
end

function [removedsomething] = rmlower(neighbor,previous,lowernames)
    previous = [previous,neighbor];
    removedsomething = true;
    lowers = previous(ismember(previous,lowernames));
    for n=1:length(lowernames)
        if sum(count(lowers,lowernames{n})) == 1 || sum(count(lowers,lowernames{n})) == 0
            continue
        else
            removedsomething = false;
            return
        end
    end
end

function bool = isupper(str)
    bool = strcmp(upper(str),str);
end