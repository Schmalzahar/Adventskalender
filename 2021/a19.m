%% Day 19
input = readmatrix("input_a19.txt","OutputType","string");
% x inc right, y inc down
% all coordinates are relative. The absolute coordinate is the relative
% coordinate of the first scanner, which is at (0,0,0)
scanners = [];

j=1;
for i=1:height(input)
    if ismissing(input(i,2))
        j = j + 1;
        continue
    end
    scanners(i,:,j) = input(i,:);
end
needed = 12;

roti = [0,90,-90,180];
rots = double.empty;
for i=1:4
    for j=1:4
        for k=1:4
            rots(:,:,end+1) = rotx(roti(i)) * roty(roti(j)) * rotz(roti(k)); % Phased array system toolbox
        end
    end
end
rots = uq(rots);
%%
% find all distances and matrices
options = nchoosek(1:size(scanners,3),2);
% distance to s1
dists = zeros(height(options),3);
matrixes = zeros(3,3,height(options));
tic
for i=1:height(options)
    [f, x,y,z, mat] = findxyz(re(scanners(:,:,options(i,1))),re(scanners(:,:,options(i,2))),needed, rots);
    if f
        dists(i,1) = x;
        dists(i,2) = y;
        dists(i,3) = z;
        matrixes(:,:,i) = mat;
        disp("Pair found between "+options(i,1)+" and "+ options(i,2))
    end
end

%%
[dists, matrixes] = fillMissing(dists, matrixes, options);
% Transform to system 1
beacons = re(scanners(:,:,1));

for i=1+1:size(scanners,3)
    % Transform system i to system k
    new_data = trans(options, dists, matrixes, scanners, i, 1);
    if new_data == 0
        disp("Not enough data")
        return
    end
    bea = cat(1,beacons, new_data);
    beacons = unique(bea,"rows");    
end
length(beacons)
toc
%% Manhatten distance
maxdis = 0;
for i=1:height(options)
    op1 = options(i,1);
    op2 = options(i,2);
    if op1 == 1
        dist1 = [0 0 0];
    else
        dist1 = dists(op1-1,:);
    end
    dist2 = dists(op2-1,:);    

    dis = sum(abs(dist1'-dist2'));
    if dis > maxdis
        maxdis = dis;
    end
end
maxdis

function [dist, matrixes] = fillMissing(dist, matrixes, options)
    for i=1:height(options)
        % go through each missing entry
        if all(dist(i,:) == 0)
            %missing
            % we need to transform from options(i,2) to options(i,1)
            old = options(i,2);
            new = options(i,1);
            % available
            avop = options(~all(dist == 0,2),:);
            temp = avop';
            g = graph(temp(1,:),temp(2,:));
            %plot(g)
            shpath = shortestpath(g,new,old);
            mat = eye(3);
            for j=1:length(shpath)-1
                % transformation matrix between shpath(j) and
                % shpath(j+1). if shpath(j) > shpath(j+1), you need the
                % transpose
                if shpath(j) < shpath(j+1)
                    m_temp = matrixes(:,:,(all((options == [shpath(j) shpath(j+1)]),2)));
                else
                    m_temp = matrixes(:,:,(all((options == [shpath(j+1) shpath(j)]),2)))';
                end
                mat = mat * m_temp;
            end
            matrixes(:,:,i) = mat;             
        end
    end
    for i=1:height(options)
        % go through each missing entry
        if all(dist(i,:) == 0)
            % distance
            old = options(i,2);
            new = options(i,1);
            % available
            avop = options(~all(dist == 0,2),:);
            temp = avop';
            g = graph(temp(1,:),temp(2,:));
            %plot(g)
            shpath = shortestpath(g,new,old);
            dis = 0;
            for j=1:length(shpath)-1
                % transform the distance to the 1 system
                if shpath(j) < shpath(j+1)
                    d_temp = dist((all((options == [shpath(j) shpath(j+1)]),2)),:);
                    if shpath(j) ~= 1                        
                        d_trans = (matrixes(:,:,(all((options == [1 shpath(j)]),2))) * d_temp')';
                    else
                        d_trans = d_temp;
                    end
                else
                    d_temp = -dist((all((options == [shpath(j+1) shpath(j)]),2)),:);
                    if shpath(j+1) ~= 1
                        d_trans = (matrixes(:,:,(all((options == [1 shpath(j+1)]),2))) * d_temp')';
                    else
                        d_trans = d_temp;
                    end
                end
                dis = dis + d_trans;
            end
            dist(i,:) = dis;
        end
    end
end

function new_s = trans(options,dists, matrixes, scanners, old, new)
    % Transform system 2 to system 1
    opa = options(:,1) == new;
    opb = options(:,2) == old;
    ops = opa & opb;
    availdists = dists(ops,:);
    if all(availdists == 0)
        new_s = 0;
        return
    end
    best_one = find(availdists,1);
    num = find(ops,best_one);
    num = num(end);
    bestdist = dists(num,:);
    bestmatr = matrixes(:,:,num);
    % transform the beacons
    new_s = bestdist + ro(bestmatr,re(scanners(:,:,old)));
end

function [foundy, yrel1, s1b, s2b, rmat] = findy(s1, s2, needed, rots, rmatx)
    % The first row of the rot matr is known
    yrots = gnr(rots,rmatx(1,:));
    ys1 = s1(:,2);
    for rot_ii = 1:4
        rmat = yrots(:,:,rot_ii);
        rs2 = ro(rmat,s2);
        ys2 = rs2(:,2);
        [a,b] = meshgrid(ys1,ys2);
        [yrel1,numOc] = mode(a-b,'all');        
        if numOc >= needed
            s1b = s1;
            s2b = s2;
            foundy = true;
            return
        end
    end
    foundy = false;
    yrel1 = 0;s1b=0;s2b=0;rmat=0;
end

function [found, xrel1, yrel1, zrel1, rmat_out] = findxyz(s1, s2, needed, rots)
    % get the correct rotations. In this first step, the z-axis stays
    %xrots = gnr(rots,3);
    xrots = rots;
    xs1 = s1(:,1);
    found = false;
    for rot_i=1:size(xrots,3)
        rmat = xrots(:,:,rot_i);
        rs2 = ro(rmat,s2);
        xs2 = rs2(:,1);
        [a,b] = meshgrid(xs1,xs2);
        [xrel11,numOc] = mode(a-b,'all');
        if numOc >= needed
            % x pos of the beacons
            memx1 = ismember(xs1,xs2+xrel11);
            xb1 = xs1(memx1);                
            memx2 = ismember(xs2+xrel11,xs1);
            xb2 = xs2(memx2)+xrel11;
            s1b = s1(memx1,:);
            s2b = s2(memx2,:);
            lenx1 = length(xb1);
            lenx2 = length(xb2);

            if lenx1 ~= lenx2
                indexes1 = multiCheck(xb1);
                indexes2 = multiCheck(xb2);                
                for i=1:length(indexes1)
                    ind1 = 1:lenx1;
                    if indexes1 ~= 0                        
                        ind1(indexes1(i)) = [];
                    end
                    for j=1:length(indexes2)
                        ind2 = 1:lenx2;
                        if indexes2 ~= 0
                            ind2(indexes2(i)) = [];
                        end
                        oriloop = getR(xb2(ind2),xb1(ind1));
                        [found, xrel1, yrel1, zrel1, rmat_out] = findy_outer(s1b(ind1,:), s2b(ind2,:), needed, rots, rmat, xrel11, oriloop);
                        if found
                            return
                        end
                    end
                end
                % Not a match
                found = false;
                xrel1 = 0;yrel1=0;zrel1=0;rmat_out=0;
                return
            end

            % check for multiple occurances
            indis1 = multiCheck(xb1);
            if ~indis1==0
                if lenx1 == lenx2 && lenx1 > 12
                    % should work? test y
                    indis2 = multiCheck(xb2);
                    % are they the same?
                    if all(xb1(indis1) == xb2(indis2))
                        % (shoud work)
                    else
                        % not the same
                        ind = 1:lenx1;  
                        for k=1:2
                            ind1 = ind;
                            ind1(indis1(k)) = [];
                            s1b_test = s1b(ind1,:);
                            for kk=1:2
                                ind2 = ind;
                                ind2(indis2(k)) = [];
                                s2b_test = s2b(ind2,:);
                                ori = getR(xb2(ind2),xb1(ind1));             
                                [found, xrel1, yrel1, zrel1, rmat_out] = findy_outer(s1b_test, s2b_test, needed, rots, rmat, xrel11, ori);
                                if found
                                    return
                                end
                            end
                        end

                    end
                end
                % We have multiple occurances for both s1b and s2b, we
                % need to check all possible combinations
                indis2 = multiCheck(xb2);
                for k=1:length(indis1)
                    for kk=1:length(indis2)
                        ind1 = (1:lenx1)';
                        ind2 = (1:lenx2)';
                        ind_k1 = ind1;
                        ind_k2 = ind2;
                        if kk == 2
                            ind_k2(indis2) = ind_k2(indis2(end:-1:1));
                        end
                        if k == 2
                            ind_k1(indis1) = ind_k1(indis1(end:-1:1));
                        end
                        s1b_ind = s1b(ind_k1,:);
                        s2b_ind = s2b(ind_k2,:);
                        ori = getR(xb2,xb1);             
                        [found, xrel1, yrel1, zrel1, rmat_out] = findy_outer(s1b_ind, s2b_ind, needed, rots, rmat, xrel11, ori);
                        if found
                            return
                        end
                    end
                end
            end
            
            % normal case
            ori = getR(xb2,xb1);             
            [found, xrel1, yrel1, zrel1, rmat_out] = findy_outer(s1b, s2b, needed, rots, rmat, xrel11, ori);
        end
    end
    if ~found
        % No match between s1 and s2 found
        found = false;
        xrel1 = 0;yrel1=0;zrel1=0;rmat_out=0;
        return
    end
end

function [found, xrel1, yrel1, zrel1, rmat_out] = findy_outer(s1b, s2b, needed, rots, rmat, xrel11, ori)
    % continue with y
    while true
        [foundy, yrel11, ~, ~, rmat_out] = findy(s1b, s2b, needed, rots, rmat);
        if foundy
            for j=1:size(ori,3)
                % with the rmat known, we can calculate the distances: 
                % 0^S_10 = 0^B_B10 - 0^B_B11, with 0^B_B11 = R * 1^B_B11
                vb_2 = ro(rmat_out,s2b);
                dis = s1b - ori(:,:,j) * vb_2;                
                xrel1 = dis(1,1);
                yrel1 = dis(1,2);  
                zrel1 = dis(1,3);                % found!
                found = true;
                return
            end
        end
        xrel1 = 0;yrel1=0;zrel1=0;rmat_out=0;
        found = false;
        return
    end
end

function R = getR(p0,p1)
    R = zeros(size(p0,1));
    for i=1:size(p0,1)
        R(:,i) = p1 == p0(i);
    end
    if multiCheck(p0) ~=0
        % We need to format R, also there are multiple matrices that work
        mp0 = multiCheck(p0);
        mp1 = multiCheck(p1);
        % length(mp0) options
        R1 = R;
        R2 = R;
        R1(mp1(1),mp0(1)) = 0;
        R1(mp1(2),mp0(2)) = 0;
        R2(mp1(2),mp0(1)) = 0;
        R2(mp1(1),mp0(2)) = 0;
        R(:,:,1) = R1;
        R(:,:,2) = R2;
    end
end

function Ao = gnr(A,ax)
    [n,m,~]=size(A);
    a=reshape(A,n,[],1);
    b=reshape(a(:),n*m,[])';
    if height(ax) == 1
        id = [1 4 7];
    end
    Ao = reshape(b(all(b(:,id)==ax,2),:)',n,m,[]);
end

function m = re(m)
    m = m(m(:,1)~=0,:);
end

function vo = ro(R,v)
    vo = zeros(size(v));
    for i=1:height(v)
        vo(i,:) = (R * v(i,:)')';
    end
end

function out = multiCheck(vec)
    sv = sort(vec);
    repeatedElements = unique(sv(~diff(sv)));
    indexes = [];
    for k=1:length(repeatedElements)
        indexes = [indexes, find(vec == repeatedElements(k))];
    end
    if isempty(indexes)
        out = 0;
    else
        out = indexes;
    end
end

function Ao = uq(A)
    if sum(sum(A(:,:,1))) == 0
        A = A(:,:,2:end);
    end
    [n,m,p]=size(A);
    a=reshape(A,n,[],1);
    b=reshape(a(:),n*m,[])';
    c=unique(b,'rows','stable')';
    Ao = reshape(c,n,m,[]);
end