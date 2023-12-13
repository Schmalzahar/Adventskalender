input = [""; readlines('a13.txt');""];
spl = find(input == "");
res = 0;
tic
for i=2:length(spl)
    block = char(input(spl(i-1)+1:spl(i)-1));
    tcol = reshape(block,size(block,1),1,[]);
    trow = reshape(block',1,size(block,2),[]);
    equalCol = squeeze(all(tcol == block));
    equalRow = squeeze(all(trow == block,2));
    bcol = find(all(equalCol(:,1:end-1) == equalCol(:,2:end),1));
    brow = find(all(equalRow(:,1:end-1) == equalRow(:,2:end),1));
    for bc = bcol
        sz = min(size(equalCol,1) - bc, bc);
        if all(sum(equalCol(bc-sz+1:bc+sz,bc-sz+1:bc+sz))==2)
            res = res + bc;
        end
    end
    for br = brow
        sz = min(size(equalRow,1)-br,br);
        if all(sum(equalRow(br-sz+1:br+sz,br-sz+1:br+sz))==2)
            res = res + 100 * br;
        end
    end
end
toc
res