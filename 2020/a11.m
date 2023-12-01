mat = char(readlines("input_11.txt"))-'L';
new_mat = mat;
while true
    for i=1:height(mat)
        for j=1:width(mat)
            if mat(i,j) == 0 && sadj(mat,i,j) == 0
                 new_mat(i,j) = 1;
            elseif mat(i,j) == 1 && sadj(mat,i,j) >= 4
                new_mat(i,j) = 0;
            end
        end
    end
    if all(new_mat == mat,"all")
        res = sum(new_mat == 1,"all");
        disp("Result part 1: "+res)
        break
    end
    mat = new_mat;
end
%% Part 2
mat = char(readlines("input_11.txt"))-'L';
new_mat = mat;
while true
    for i=1:height(mat)
        for j=1:width(mat)
            if mat(i,j) == 0 && sadj2(mat,i,j) == 0
                 new_mat(i,j) = 1;
            elseif mat(i,j) == 1 && sadj2(mat,i,j) >= 5
                new_mat(i,j) = 0;
            end
        end
    end
    if all(new_mat == mat,"all")
        res = sum(new_mat == 1,"all");
        disp("Result part 2: "+res)
        break
    end
    mat = new_mat;
end

function out = sadj(mat,i,j)
    if i==1
        di = [1 2];
    elseif i == height(mat)
        di = [height(mat)-1 height(mat)];
    else
        di = [i-1 i i+1];
    end
    if j==1
        dj = [1 2];
    elseif j == width(mat)
        dj = [width(mat)-1 width(mat)];
    else
        dj = [j-1 j j+1];
    end
    out = sum(mat(di,dj) == 1,"all") - double(mat(i,j) == 1);
end

function out = sadj2(mat,i,j)
    out = 0;    
    id1s = {i+1:height(mat);i-1:-1:1;i}';
    id2s = {j+1:width(mat);j-1:-1:1;j}';
    for ii=1:length(id1s)
        for jj=1:length(id2s)
            diag = false;
            if ii==3 && jj==3
                continue
            elseif (1<=ii && ii<=2) && (1<=jj && jj<=2)
                diag = true;
            end
            out = out + findFirst(mat,id1s{ii},id2s{jj},diag);
        end
    end
end

function out = findFirst(mat,ir,jr,diag)
   if isempty(ir) || isempty(jr)
       out = 0;
       return
   end
   if ~diag
      if length(ir) == 1 && length(jr) > 1
           ir = ir * ones(size(jr));
       elseif length(jr) == 1 && length(ir) > 1
           jr = jr * ones(size(ir));
      end
   end
   if diag
       if length(jr) < length(ir)
           ir = ir(1:length(jr));
       elseif length(ir) < length(jr)
           jr = jr(1:length(ir));
       end
   end
   res = find(evMat(mat,ir,jr) == 1 | evMat(mat,ir,jr) == 0,1);
   if isempty(res)
       out = 0;
       return
   end
   out = mat(ir(res),jr(res));
end

function out = evMat(mat,ir,jr)
    out = nan(size(ir));
    for i=1:length(ir)
        out(1,i) = mat(ir(i), jr(i));
    end
end