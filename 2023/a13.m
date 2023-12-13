input = [""; readlines('a13.txt');""];
spl = find(input == "");
res = NaN(size(2:length(spl),2),1);
res2 = NaN(size(2:length(spl),2),1);
multis = [1 100]; 
tic
for i=2:length(spl)
    if i == 12
        test = 1;
    end
    block = char(input(spl(i-1)+1:spl(i)-1));
    tcol = reshape(block,size(block,1),1,[]);
    trow = reshape(block',1,size(block,2),[]);
    equalCol = squeeze(all(tcol == block));
    equalRow = squeeze(all(trow == block,2));
    bcol = find(all(equalCol(:,1:end-1) == equalCol(:,2:end),1));
    brow = find(all(equalRow(:,1:end-1) == equalRow(:,2:end),1));
    % if length(bcol)+length(brow) < 2
    % smudge on the row/col that is supposed to be the same
    equalCol1 = squeeze(sum(tcol == block)>=size(block,1)-1);
    equalRow1 = squeeze(sum(trow == block,2)>=size(block,2)-1);
    bcol1 = find(all(equalCol1(:,1:end-1) == equalCol1(:,2:end),1));
    brow1 = find(all(equalRow1(:,1:end-1) == equalRow1(:,2:end),1));
    colMat = squeeze(sum(tcol == block,1));
    eqCM = max(0,colMat - size(block,1) + 2);
    bcol2 = find(all(eqCM(:,1:end-1) - eye(size(eqCM,1),size(eqCM,1)-1)== eqCM(:,2:end) - circshift(eye(size(eqCM,1),size(eqCM,1)-1),1,1)));
    rowMat = squeeze(sum(trow == block,2));
    eqRM = max(0,rowMat - size(block,2) + 2);
    brow2 = find(all(eqRM(:,1:end-1) - eye(size(eqRM,1),size(eqRM,1)-1)== eqRM(:,2:end) - circshift(eye(size(eqRM,1),size(eqRM,1)-1),1,1)));

    

        % smudge_on_row = 1;
    % end

    bdir = {bcol, brow};
    bdir1 = {bcol1, brow1};
    tdir = {equalCol, equalRow};    
    tdir1 = {equalCol1, equalRow1};
    % if smudge_on_row
    %     bdir = bdir1; tdir = tdir1;
    % end
    for j=1:2
        
        % for bd = bdir1{j}
        for k=1:length(bdir1{j})
            bd = bdir1{j}(k);
            sz = min(size(tdir1{j},1) - bd, bd);
            tdir1{j}(bd-sz+1:bd+sz,bd-sz+1:bd+sz)
            if all(diag(tdir1{j}(bd-sz+1:bd+sz,bd-sz+1:bd+sz))) && all(diag(tdir1{j}(bd-sz+1:bd+sz,bd+sz:-1:bd-sz+1))) && ismember(bd,bdir{j})

                res(i-1) = multis(j) * bd;


            
            elseif all(diag(tdir1{j}(bd-sz+1:bd+sz,bd-sz+1:bd+sz))) && sum(diag(tdir1{j}(bd-sz+1:bd+sz,bd+sz:-1:bd-sz+1))) == 2*(sz-1)
                % res(i-1) = multis(j) * bd;
                test = 1;
            elseif all(tdir1{j}(bd-sz+1:bd,bd-sz+1:bd+sz) == flip(tdir1{j}(bd+sz:-1:bd+1,bd-sz+1:bd+sz),2),'all')
                % if all(tdir{j}(bd-sz+1:bd,bd-sz+1:bd) == eye(sz),'all')
                if all(diag(tdir1{j}(bd-sz+1:bd+sz,bd-sz+1:bd+sz)))
                    test = 1;
                    res2(i-1) = multis(j) * bd;
                else
                    ts = 1;
                end
                tdir1{j}(bd-sz+1:bd,bd-sz+1:bd+sz)
                flip(tdir1{j}(bd+sz:-1:bd+1,bd-sz+1:bd+sz),2)
                diag(tdir1{j}(bd-sz+1:bd+sz,bd+sz:-1:bd-sz+1))
            end
        end
    end
    % smudge_on_row = 0;
end
toc
res