map = zeros(300);
X = 1:height(map); Y = 1:width(map);

serial = 1955;
out = arrayfun(@(y) [arrayfun(@(x)pL(x,y,serial),X,'UniformOutput',false)],Y,'UniformOutput',false);
out1 = reshape(cell2mat([out{:}]),height(map),[])';

%% part 1 find the max region
out2 = conv2(out1,ones(3));
out3 = out2(3:end-2,3:end-2);
[maxVal,linInd] = max(out3,[],"all");
[yc,xc] = ind2sub(size(out3),linInd);
sprintf('%d,%d',xc,yc)
%% part 2
maxVal_p2 = 0;
for i=1:300
    outi = conv2(out1,ones(i));
    out3i = outi(i:end-i+1,i:end-i+1);
    [maxVali,linIndi] = max(out3i,[],"all");
    [yci,xci] = ind2sub(size(out3i),linIndi);
    if maxVali > maxVal_p2
        maxVal_p2 = maxVali;
        sprintf('%d:%d,%d,%d',maxVali,xci,yci,i)
    end    
end
function out = pL(x,y,serial)
    pl3 = ((x + 10) * y + serial) * (x + 10);
    pl4 = num2str(pl3);
    if length(pl4) > 2
        pl5 = str2double(pl4(end-2));
    else
        pl5 = 0;
    end
    pl6 = pl5 - 5;
    out = pl6;
end