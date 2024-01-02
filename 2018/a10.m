input = readlines('a10.txt');
pos = zeros(height(input),2);
vels = zeros(height(input),2);
for i=1:height(input)
    line = input(i);
    cont = line.extractBetween('<','>').split(',').double();
    pos(i,:) = cont(1,:);
    vels(i,:) = cont(2,:);
end
%%
npos = pos + 10454*vels;
for t=1:1
    map = zeros(max(npos(:,2))-min(npos(:,2))+1,max(npos(:,1))-min(npos(:,1))+1);
    inds = sub2ind(size(map),npos(:,2)-(min(npos(:,2)))+1,npos(:,1)-(min(npos(:,1)))+1);
    map(inds) = 1;
    imagesc(map)
    %
    npos = npos + nvels;
end