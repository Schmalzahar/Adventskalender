input = readlines("a25.txt").split(': ');
% build a graph
tree = graph;
for i=1:height(input)
    tree = tree.addedge(input(i,1),input(i,2).split(' ')');
end
plot(tree)
% just look at it
tree = tree.rmedge('vnm','qpp');
tree = tree.rmedge('rhk','bff');
tree = tree.rmedge('vkp','kfr');
plot(tree)
sum(tree.conncomp == 1) * sum(tree.conncomp == 2)