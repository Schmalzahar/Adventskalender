input = readlines("a12.txt");
G = graph(1,1,'omitselfloops');
G.Nodes.Name = '0';
for i=1:height(input)
    line = split(input(i),'<->');
    left = extract(line(1),digitsPattern);
    right = extract(line(2),digitsPattern);
    if ~contains(G.Nodes.Name, left)
        G = addnode(G,left);
    end
    if ~contains(G.Nodes.Name,right)
        G = addnode(G,right);
    end
    G = addedge(G,left,right);
end
conn = conncomp(G);
sum(conn==1)
max(conn)