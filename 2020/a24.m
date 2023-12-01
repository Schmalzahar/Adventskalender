input = readlines("input_24.txt");
tic
tiles = zeros(height(input),3);
plots = false;
for i=1:height(input)
    px = 0;
    py = 0;
    line = char(input(i));
    j = 1;
    while j<=length(line)
        switch line(j)
            case 's'
                switch line(j+1)
                    case 'e'
                        px = px + sqrt(3);
%                         px = px + 2;
                        py = py - 3;
                        
                    case 'w'
                        px = px - sqrt(3);
%                         px = px - 2;
                        py = py - 3;
                end
                j = j+2;
            case 'n'
                switch line(j+1)
                    case 'e'
                        px = px + sqrt(3);
%                         px = px + 2;
                        py = py + 3;
                    case 'w'
                        px = px - sqrt(3);
%                         px = px - 2;
                        py = py + 3;
                end
                j = j+2;
            case 'e'
                px = px + 2*sqrt(3);
%                 px = px + 4;
                j = j+1;
            case 'w'
                px = px - 2*sqrt(3);
%                 px = px - 4;
                j = j+1;
        end
    end
    tiles(i,1) = px;
    tiles(i,2) = py;
    tiles(i,3) = 1;
end
% tiles(:,1) = floor(tiles(:,1));

% [C,ia,ic] = unique(tiles(:,1:2),"rows","stable");
[C,ia,ic] = uniquetol(tiles(:,1:2),0.001,"ByRows",true);
new_tiles = zeros(height(C),3);
% hexes = [];
% colors = string.empty;
for i=1:height(ic)
    new_tiles(ic(i),1:2) = tiles(i,1:2);
%     hexes = cat(2,hexes,nsidedpoly(6,'Center',[tiles(i,2) tiles(i,1)],'SideLength',2));
    new_tiles(ic(i),3) = new_tiles(ic(i),3) + tiles(i,3);
%     if mod(new_tiles(ic(i),3),2) == 1
%         colors = [colors,'#303030'];
%     else
%         colors = [colors,'#B0B0B0'];
%     end
end
count = sum(new_tiles(:,3)==1);
disp("Result part 1: "+count)
if plots
    p = plot(hexes);
    hold on
    for i=1:size(p,2)
        p(i).FaceColor = colors(i);
        p(i).FaceAlpha = 1;
    end
    axis equal
end
%% Part 2
days = 100;
for d=1:days
    aa = [];
%     hexes = [];
%     ahexes = [];
%     colors = string.empty;
%     acolors = string.empty;
    tiles = new_tiles;
    for i=1:height(tiles)
        line = tiles(i,:);
%         hexes = cat(2,hexes,nsidedpoly(6,'Center',[tiles(i,2) tiles(i,1)],'SideLength',2));
        [additional_tiles,numBlack] = adjacentBlack(line,tiles);
        aa = cat(1,aa,additional_tiles);
        if size(numBlack,1) > 1
            tes = 4;
        end
        if (mod(line(3),2) == 1 && (numBlack == 0 || numBlack >2)) || (mod(line(3),2) == 0 && numBlack == 2)
            new_tiles(i,3) = new_tiles(i,3) + 1;
        end    
%         if mod(new_tiles(i,3),2) == 1
%             colors = [colors,'#303030'];
%         else
%             colors = [colors,'#B0B0B0'];
%         end
    end
    if plots
        figure()
        hold on
        pd = plot(hexes);
        axis equal
        for i=1:size(pd,2)
            pd(i).FaceColor = colors(i);
            pd(i).FaceAlpha = 1;
        end
    end

    [t,ta,ac] = uniquetol(aa(:,1:2),0.001,"ByRows",true);
    aaa = NaN(height(t),2);
    for i=1:height(t)
        if ~ismembertol(t(i,1:2),tiles(:,1:2),0.001,'ByRows',true)
            aaa(i,1:2) = t(i,1:2);
%             ahexes = cat(2,ahexes,nsidedpoly(6,'Center',[t(i,2) t(i,1)],'SideLength',2));
        end
    end
    aaa = aaa(~isnan(aaa(:,1)),:);
    aaa = cat(2,aaa,zeros(height(aaa),1));
    aaa_with_old = cat(1,tiles,aaa);
    aaa_with_old = unique(aaa_with_old,"rows"); % to sort
    for i=1:height(aaa)
        line = aaa(i,:);
        [~,numBlack] = adjacentBlack(line,aaa_with_old);
        if numBlack == 2
            aaa(i,3) = 1;
%             acolors = [acolors,'#303030'];
        else
%             acolors = [acolors,'#B0B0B0'];
        end
    end
    if plots
    %     figure()
        pa = plot(ahexes);
        axis equal
        for i=1:size(pa,2)
            pa(i).FaceColor = acolors(i);
            pa(i).FaceAlpha = 1;
        end
    end
    new_tiles = unique(cat(1,new_tiles,aaa),"rows");
    count = sum(mod(new_tiles(:,3),2)==1);
    fprintf("Day %d: %d\n",d,count)
end
count
toc

function [new_tiles,black] = adjacentBlack(line,tiles)
    black = 0;
    xmin = line(1)-4; ymin = line(2)-3;
    xmax  = line(1)+4; ymax = line(2)+3;
    tiles = tiles(tiles(:,1)>xmin & tiles(:,1)<xmax,:);
    tiles = tiles(tiles(:,2)>=ymin & tiles(:,2)<=ymax,:);
    new_tiles = [];
    [new_tiles, black] = findHex(2*sqrt(3),0,line,tiles,new_tiles,black);
    [new_tiles, black] = findHex(-2*sqrt(3),0,line,tiles,new_tiles,black);
    [new_tiles, black] = findHex(sqrt(3),3,line,tiles,new_tiles,black);
    [new_tiles, black] = findHex(sqrt(3),-3,line,tiles,new_tiles,black);
    [new_tiles, black] = findHex(-sqrt(3),3,line,tiles,new_tiles,black);
    [new_tiles, black] = findHex(-sqrt(3),-3,line,tiles,new_tiles,black);
end

function [new_tiles, black] = findHex(x,y,line,tiles, new_tiles, black)
    id = ismembertol(tiles(:,1:2),[line(1)+x line(2)+y],0.001,'ByRows',true);
    if any(id)
        black = black + mod(tiles(id,3),2);
    else
        new_tiles = cat(1,new_tiles,[line(1)+x line(2)+y 0]);
    end
end