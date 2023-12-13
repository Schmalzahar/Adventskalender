input = [""; readlines('a13.txt');""];
spl = find(input == "");
res = 0;
multis = [1 100]; 
tic
for i=2:length(spl)
    block = char(input(spl(i-1)+1:spl(i)-1));
    tcol = reshape(block,size(block,1),1,[]);
    trow = reshape(block',1,size(block,2),[]);
    equalCol = squeeze(all(tcol == block));
    equalRow = squeeze(all(trow == block,2));
    bcol = find(all(equalCol(:,1:end-1) == equalCol(:,2:end),1));
    brow = find(all(equalRow(:,1:end-1) == equalRow(:,2:end),1));
    bdir = {bcol, brow};
    tdir = {equalCol, equalRow};    
    for j=1:2
        for bd = bdir{j}
            sz = min(size(tdir{j},1) - bd, bd);
            if all(tdir{j}(bd-sz+1:bd,bd-sz+1:bd+sz) == tdir{j}(bd+sz:-1:bd+1,bd-sz+1:bd+sz),'all')
                res = res + multis(j) * bd;
            end
        end
    end
end
toc
res