a = str2double('289326'); 
r = ceil((sqrt(a)-1)/2);
min_o = (2*(r-1)+1)^2+1;
max_o = (2*r+1)^2;
if a < min_o + 2*r
    ridx = r;
    uidx = -(r-1) + (a - min_o);
elseif a < min_o + 4*r
    uidx = r;
    ridx = r-1-(a - (min_o + 2*r));
elseif a < min_o + 6*r
    ridx = -r;
    uidx = r-1 - (a - (min_o + 4*r));
else
    ridx = -r+1 + (a - (min_o + 6*r));
    uidx = -r;
end
abs(uidx)+abs(ridx)

%% Part 2
%https://oeis.org/A141481