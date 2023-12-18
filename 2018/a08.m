input = readlines('a08.txt').split(' ').double()';
[meta, ~, node_values] = header(input);
sum(meta)
node_values

function [meta, input, node_values] = header(input)
    num_child_nodes = input(1);
    num_meta_entries = input(2);
    input = input(3:end);
    meta = [];
    node_values = [];
    if num_child_nodes > 0
        for i=1:num_child_nodes
            [new_meta, input, new_node_values] = header(input);
            meta = [meta new_meta];
            node_values = [node_values new_node_values];
        end
    else
        meta = input(1:num_meta_entries);
        input = input(num_meta_entries+1:end);
        node_values = sum(meta);
        return
    end
    new_meta = input(1:num_meta_entries);
    meta = [meta new_meta];
    input = input(num_meta_entries+1:end);
    node_values = sum(arrayfun(@(x) node_values(x),new_meta(new_meta <= length(node_values))));
end