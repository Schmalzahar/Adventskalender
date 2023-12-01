%% Day 10
a = readlines("a10.txt");
i = 1;
reg = 1;
signals = 0;
image = zeros(240,1);
for l=1:length(a)
    [i, signals, image] = cycle(i, reg, signals, image);
    line = char(a(l));
    if length(line)>4
        num = strsplit(line);
        num = str2double(num(2));
        [i, signals, image] = cycle(i, reg, signals, image);
        reg = reg + num;
    end
end
signals
imshow(reshape(image, 40,6)')
function [i, signals, image] = cycle(i, reg, signals, image)
    if ismember(i, [20, 60, 100, 140, 180, 220])
        signals = signals + reg*i;
    end
    if (reg+2>=mod(i,40)) && (mod(i,40)>=reg)
        image(i,1) = 1;
    end
    i = i+1;
end