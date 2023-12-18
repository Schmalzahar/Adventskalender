input = readlines("a18.txt");
xv = [1]; yv = [1];
for i=1:height(input)
    line = input(i);
    dir = line.extractBefore(' ');
    len = line.extractBetween(' ', ' ').double();
    code = char(line.extractBetween('#',')'));
    % dist_m = code(1:5);
    % len = hex2dec(dist_m);
    % dir = code(6);
    switch dir
        case {'R', '0'}
            xv = [xv; xv(end)];
            yv = [yv; yv(end) + len];
        case {'L','2'}
            xv = [xv; xv(end)];
            yv = [yv; yv(end) - len];
        case {'D','1'}
            xv = [xv; xv(end)+len];
            yv = [yv; yv(end)];
        case {'U','3'}
            xv = [xv; xv(end)-len];
            yv = [yv; yv(end)];
    end
end

%%
polyin = polyshape(xv,yv);
vert = polyin.Vertices;
area = 0;
plot(polyin)
hold on
while true
    vert = polyin.Vertices;
    inds = find(vert(:,1) == min(vert(:,1),[],1));
    prev = inds(1)-1;
    if prev == 0
        prev = length(vert);
    end
    next = inds(2)+1;
    if next > length(vert)
        next = 1;
    end
    if vert(prev,1) < vert(next,1)
        new_rect = [vert(inds(1),:); vert(inds(2),:); vert(prev,1) vert(inds(2),2);vert(prev,:)];
        rem_poly = polyshape(new_rect);
        area = area + prod(max(new_rect)-min(new_rect)+1);
        plot(rem_poly)
        polyin = subtract(polyin, rem_poly);
        plot(polyin)
    else
        new_rect = [vert(inds(1),:); vert(inds(2),:); vert(next,:);vert(next,1) vert(inds(1),2) ];
        rem_poly = polyshape(new_rect);
        area = area + prod(max(new_rect)-min(new_rect)+1);
        plot(rem_poly)
        polyin = subtract(polyin, rem_poly);
        plot(polyin)
    end
    if isempty(polyin.Vertices)
        break
    end
end


%%

% poly2 = polybuffer(polyin,1,"JointType","miter");
plot(polyin)
% hold on
% plot(poly2)
% line length
format long
numsides(polyin)
height(input)
area(polyin) + perimeter(polyin)


% map = zeros(max(xv)-min(xv)+2,max(yv)-min(yv)+2);
% 
% % xq = 0:10; yq = 0:10;
% [xq,yq] = find(map == 0);
% in = inpolygon(xq,yq,xv-min(xv)+1,yv-min(yv)+1);
% sum(in)
% plot(xv-min(xv)+1,yv-min(yv)+1)
% axis equal
% hold on
% plot(xq(in),yq(in),'r+')
% plot(xq(~in),yq(~in),'bo')