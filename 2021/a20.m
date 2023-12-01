%% Day 20
input = fileread("input_a20.txt");%,"OutputType","string");
tic
spl = strsplit(input,newline);
alg = spl{1};
balg = char(replace(replace(string(alg),'#','1'),'.','0'));
inp_img = strtrim(spl(3:end));
inp_img = cat(1,inp_img{:});

binp_img = char(replace(replace(string(inp_img),'#','1'),'.','0')) - '0';
steps = 50;
or_size = width(binp_img);
for i=1:steps
    % increase the image by n around every border
    n=6;
    nbinp_img = zeros(width(binp_img)+2*n);
    next_img = nbinp_img;
    nbinp_img(n+1:end-n,n+1:end-n) = binp_img;
    for hl = 2:width(nbinp_img)-1
        for vl = 2:height(nbinp_img)-1
            d = '';
            for ii=-1:1
                for jj=-1:1
                    d = append(d,num2str(nbinp_img(vl+ii,hl+jj)));
                end
            end
            de = bin2dec(d);
            % find the match
            match = balg(1+de);
            next_img(vl,hl) = str2double(match);
        end
    end
    binp_img = next_img;
    if mod(i,2) == 0 % clean up the img       
        binp_imga = binp_img(2*n - 1:end-2*n+2,2*n - 1:end-2*n+2);
%         montage({binp_img binp_imga},"Size",[1 2])
        binp_img = binp_imga;
    end
end
sum(sum(binp_img))
toc