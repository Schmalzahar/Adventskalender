input = char(readlines("input_8.txt"))-'0';
imw = 25;
imh = 6;
num = imw*imh;
numZeroDigits = num;
res = 0;
img = 2 * ones(imh,imw);
for i=1:numel(input)/num
    layer = input(1+(i-1)*num:i*num);
    if numZeroDigits > sum(layer == 0)
        numZeroDigits = sum(layer == 0);
        res = sum(layer == 1) * sum(layer == 2);
    end
    for j=1:imh
        for k=1:imw
            pix = layer(k + (j-1)*imw);
            if pix == 0 || pix == 1
                if img(j,k) == 2
                    img(j,k) = pix;
                end
            end
        end
    end
end
res
imshow(img)