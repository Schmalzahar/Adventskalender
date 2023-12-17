input = sortrows(readlines('a07.txt').extractBetween(' ',' '),1);
left_letters = char(input(:,1));
right_letters = char(input(:,4));
letters = char((1:26)+64);
start = unique(left_letters(~ismember(left_letters, right_letters)));
conns = digraph(string(left_letters), string(right_letters));
step_extra_dur = 0;
T = table((0:20)', repelem('.',21,1), repelem('.',21,1), repelem(' ',21,1),'VariableNames',{'Second','Worker 1','Worker 2','Done'})
g = digraph;
order = start(1);
tic
order = getOrder(order, conns, T, step_extra_dur)
toc
function [order] = getOrder(order, conns, T, step_extra_dur)
    conn_edges = {};
    for j=1:length(order)
        [~,conn_edges{j,1}] = outedges(conns, order(j));
    end
    conn_edges = cat(1,conn_edges{:});
    cn_sorted = sort(conn_edges);
    % only available if all other connecting nodes to the new node are
    % already present
    cn_sorted = cn_sorted(~ismember([cn_sorted{:}],order));
    opts = indegree(conns) == 0;
    nds = conns.Nodes.Variables;
    possible = sort([nds{opts}]);
    possible = possible(~ismember(possible, order));
    for i=1:length(cn_sorted)
        [~,in_nodes] = inedges(conns, cn_sorted{i});
        if all(ismember([in_nodes{:}], order))
            possible = [possible, cn_sorted{i}];
            break
        end
    end
    possible = sort(possible);
    if isempty(possible)
        return
    end
    % new node - new possibilities
    order = [order possible(1)];
    [order] = getOrder(order, conns);
end