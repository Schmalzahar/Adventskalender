input = sortrows(readlines('a07.txt').extractBetween(' ',' '),1);
left_letters = char(input(:,1));
right_letters = char(input(:,4));
letters = char((1:26)+64);
start = unique(left_letters(~ismember(left_letters, right_letters)));
conns = digraph(string(left_letters), string(right_letters));
step_extra_dur = 60;
t_max = 1000;
T = table((0:t_max)', repelem('.',t_max+1,1), repelem('.',t_max+1,1), repelem('.',t_max+1,1), repelem('.',t_max+1,1), repelem('.',t_max+1,1), repelem(' ',t_max+1,1),'VariableNames',{'Second','Worker 1','Worker 2','Worker 3','Worker 4','Worker 5','Done'});
g = digraph;
% order = start(1);
order = '';
tic
available = start;
running = '';
for i=1:height(T)    
    for j=1:5
        if T(i,1+j).Variables == '.'
            if i>1 && T(i-1,1+j).Variables ~= '.' 
                running = running(T(i-1,1+j).Variables ~= running);
                order = [order T(i-1,1+j).Variables];
                available = getAvailable(order, conns);
                available(ismember(available, running)) = [];
            end
            if ~isempty(available)
                T(i:i+step_extra_dur+available(1)-65,j+1).Variables = repelem(available(1),available(1)-64+step_extra_dur,1);
                running = [running available(1)];
                available(1) = [];    
            end
        end
    end
end

% order = getOrder(start(1), conns)
toc

function available = getAvailable(order, conns)
    conn_edges = {};
    for j=1:length(order)
        [~,conn_edges{j,1}] = outedges(conns, order(j));
    end
    cn_sorted = sort(cat(1,conn_edges{:}));
    cn_sorted = cn_sorted(~ismember([cn_sorted{:}],order));
    opts = indegree(conns) == 0;
    nds = conns.Nodes.Variables;
    possible = sort([nds{opts}]);
    possible = possible(~ismember(possible, order));
    for i=1:length(cn_sorted)
        [~,in_nodes] = inedges(conns, cn_sorted{i});
        if all(ismember([in_nodes{:}], order))
            possible = [possible, cn_sorted{i}];            
        end
    end
    available = unique(possible);
end

function [order] = getOrder(order, conns)
    possible = getAvailable(order, conns);
    if isempty(possible)
        return
    end
    [order] = getOrder([order possible(1)], conns);
end