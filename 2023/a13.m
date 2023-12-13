input = [""; readlines('a13.txt');""];
tic
spl = find(input == "");
res = 0;
res2 = 0;
multis = [1 100]; 
for i=2:length(spl)    
    block = char(input(spl(i-1)+1:spl(i)-1));
    tcol = reshape(block,size(block,1),1,[]);
    trow = reshape(block',1,size(block,2),[]);
    equalCol = squeeze(all(tcol == block));
    equalRow = squeeze(all(trow == block,2));
    % smudge on the row/col that is supposed to be the same
    equalCol1 = squeeze(sum(tcol == block)>=size(block,1)-1);
    equalRow1 = squeeze(sum(trow == block,2)>=size(block,2)-1);
    [bcol1,~] = find(conv2(equalCol1, ones(2), 'valid') == 2^2);
    [brow1,~] = find(conv2(equalRow1, ones(2), 'valid') == 2^2);
    bdir1 = {unique(bcol1), unique(brow1)};
    tdir = {equalCol, equalRow};    
    tdir1 = {equalCol1, equalRow1};
    for j=1:2
        for k=1:length(bdir1{j})
            bd = bdir1{j}(k);
            sz = min(size(tdir1{j},1) - bd, bd);
            if all(diag(tdir{j}(bd-sz+1:bd+sz,bd-sz+1:bd+sz))) && all(diag(tdir{j}(bd-sz+1:bd+sz,bd+sz:-1:bd-sz+1)))
                res = res +  multis(j) * bd;            
            elseif all(diag(tdir1{j}(bd-sz+1:bd+sz,bd-sz+1:bd+sz))) && all(diag(tdir1{j}(bd-sz+1:bd+sz,bd+sz:-1:bd-sz+1)))
                res2 = res2 + multis(j) * bd;
            end
        end
    end
end
toc
res
res2