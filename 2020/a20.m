input = readlines("input_20.txt");
tic
ids = str2double(extract(input(1:12:end),digitsPattern));
iinput = strrep(strrep(input,'#','1'),'.','0');
images = cell(height(ids),1);
r = 1:height(images);
for i=r
    images{i} = char(iinput(2+12*(i-1):2+12*i-3));% - '0';
end
score = 1;
ss = [];
tt = [];
for i=r
    count = 0;
    img = images{i};
    [n,e,s,w] = gnesw(img);
    for j=r(r~=i)
        imgj = images{j};
        [nj,ej,sj,wj] = gnesw(imgj);
        if ~any(ismember([nj,ej,sj,wj],[n,e,s,w]))
            imgj = fliplr(imgj);
            [nj,ej,sj,wj] = gnesw(imgj);
            if ~any(ismember([nj,ej,sj,wj],[n,e,s,w]))
                imgj = flipud(imgj);
                [nj,ej,sj,wj] = gnesw(imgj);
                if ~any(ismember([nj,ej,sj,wj],[n,e,s,w]))
                    continue
                end
            end
        end
        tt(1,end+1) = ids(i);
        ss(1,end+1) = ids(j);
        count = count + 1;
    end
    if count == 2
        score = score * ids(i);
    end
end
toc
fprintf("Score: %d\n",score)
% Part 2
names = strsplit(num2str(1:max(ids)),' ');
G = graph(ss,tt,[],names);
H = subgraph(G,ids);
% plot(H)
% Build the matrix
M = zeros(sqrt(height(images))*(width(img)-2));
LM = zeros(sqrt(height(images))*(width(img)));
% find an edge
edges = [];
for edge_id=r
    if height(neighbors(G,ids(edge_id))) == 2
        edges(end+1) = edge_id;
    end
end
% edges(1): top left
% edges(2): top right
if ~(length(H.shortestpath(edges(1),edges(2))) == sqrt(height(images)))    
    temp = edges(2);
    edges(2) = edges(4);
    edges(4) = temp;
end
% edges(3) : bottom left
if ~(length(H.shortestpath(edges(1),edges(3))) == sqrt(height(images))) 
    temp = edges(3);
    edges(3) = edges(2);
    edges(2) = temp;
end
N = zeros(sqrt(height(images)));
N(1,:) = H.shortestpath(edges(1),edges(2));
N(end,:) = H.shortestpath(edges(3),edges(4));
N(:,1) = H.shortestpath(edges(1),edges(3));
N(:,end) = H.shortestpath(edges(2),edges(4));
for i=2:height(N)-1
    N(i,:) = H.shortestpath(N(i,1),N(i,end));
end
mat1 = images{N(1,1)};
for i=1:sqrt(height(images))-1
    for j=1:sqrt(height(images))-1
        mat2 = images{N(i,j+1)}; mat3 = images{N(i+1,j)};
        out = mat_right_down(mat1,mat2,mat3);
        [mat1,mat2,mat3] = out{:};
        if j==1
            newmat1 = mat3;
        end
        M(1+(i-1)*8:8+(i-1)*8,1+(j-1)*8:8+(j-1)*8) = mat1(2:end-1,2:end-1)-'0';
        M(1+(i-1)*8:8+(i-1)*8,1+(j)*8:8+(j)*8) = mat2(2:end-1,2:end-1)-'0';
        M(1+(i)*8:8+(i)*8,1+(j-1)*8:8+(j-1)*8) = mat3(2:end-1,2:end-1)-'0';
        if j<sqrt(height(images))-1
            mat1 = mat2;
        else
            mat1 = newmat1;
        end
    end
end
last_mat = mat_right_down(mat3,images{N(end,end)});
M(end-8+1:end,end-8+1:end) = last_mat(2:end-1,2:end-1)-'0';

monster = char(strrep(strrep(string(cat(1,'                  # ','#    ##    ##    ###',' #  #  #  #  #  #   ')),'#','1'),' ','2'));

%%
roughness1 = findSeaMonster(M,monster)
roughness2 = findSeaMonster(rot90(M),monster)
toc
function [n,e,s,w] = gnesw(img)
    n = bin2dec(img(1,:));
    e = bin2dec(img(:,10)');
    s = bin2dec(img(10,:));
    w = bin2dec(img(:,1)');
end

function out = mat_right_down(img1,img2,img3)
    [n1,e1,s1,w1] = gnesw(img1);
    [n2,e2,s2,w2] = gnesw(img2);    
    mem12 = ismember([n1,e1,s1,w1],[n2,e2,s2,w2]);
    mem21 = ismember([n2,e2,s2,w2],[n1,e1,s1,w1]);
    if nargin > 2
        [n3,e3,s3,w3] = gnesw(img3);
        mem13 = ismember([n1,e1,s1,w1],[n3,e3,s3,w3]);
        mem31 = ismember([n3,e3,s3,w3],[n1,e1,s1,w1]);
        if all(mem12 == [0 1 0 0])
            if all(mem21 == [0 0 0 1])
                if all(mem13 == [0 0 1 0])
                    if all(mem31 == [1 0 0 0])
                        out = {img1 img2 img3};
                        return
                    elseif all(mem31 == [0 0 1 0])
                        out = mat_right_down(img1,img2,flipud(img3));
                        return
                    else
                        out = mat_right_down(img1,img2,rot90(img3));
                        return
                    end
                elseif all(mem13 == [1 0 0 0])
                    out = mat_right_down(flipud(img1),flipud(img2),flipud(img3));
                    return
                else
                    out = mat_right_down(img1,img2,rot90(img3));
                    return
                end
            elseif all(mem21 == [0 1 0 0])
                out = mat_right_down(img1,fliplr(img2),img3);
                return
            else
                out = mat_right_down(img1,rot90(img2),img3);
                return
            end
        elseif all(mem12 == [0 0 1 0])
            out = mat_right_down(rot90(img1),img2,img3);
            return
        else
            out = mat_right_down(img1,rot90(img2),img3);
            return
        end
    else
        if all(mem12 == [0 1 0 0])
            if all(mem21 == [0 0 0 1])
                out = img2;
                return
            elseif all(mem21 == [0 1 0 0])
                out = mat_right_down(img1,fliplr(img2));
                return
            else
                out = mat_right_down(img1,rot90(img2));
                return
            end
        elseif all(mem12 == [0 0 1 0])
            out = fliplr(img2);
            return
        else
            out = mat_right_down(img1,rot90(img2));
            return
        end
    end
end

function roughness = findSeaMonster(M,monster)
    monster = monster - '0';
    monster_size = size(monster);
    m1 = monster == 1;
    any_monster = false;
    for i=1:height(M)-monster_size(1)+1
        for j=1:width(M)-monster_size(2)+1
            M_ij = M(i:monster_size(1)+i-1,j:monster_size(2)+j-1);            
            if all((m1 & m1 == (M_ij == 1)) == m1,"all")
                any_monster = true;
                M(i:monster_size(1)+i-1,j:monster_size(2)+j-1) = double(xor(m1,M_ij==1));
            end
            m2 = fliplr(m1);
            if all((m2 & m2 == (M_ij == 1)) == m2,"all")
                any_monster = true;
                M(i:monster_size(1)+i-1,j:monster_size(2)+j-1) = double(xor(m2,M_ij==1));
            end
            m3 = flipud(m1);
            if all((m3 & m3 == (M_ij == 1)) == m3,"all")
                any_monster = true;
                M(i:monster_size(1)+i-1,j:monster_size(2)+j-1) = double(xor(m3,M_ij==1));
            end
            m4 = rot90(m1,2);
            if all((m4 & m4 == (M_ij == 1)) == m4,"all")
                any_monster = true;
                M(i:monster_size(1)+i-1,j:monster_size(2)+j-1) = double(xor(m4,M_ij==1));
            end
        end
    end
    if any_monster
        roughness = sum(M,"all");
    else
        roughness = 0;
    end
end