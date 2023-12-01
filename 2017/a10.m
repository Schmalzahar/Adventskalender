input = char(readlines("a10.txt"));
input_ascii = [input+0, 17, 31, 73, 47, 23];
% lengths = str2double(extract(input,digitsPattern))';
lengths = input_ascii;
list = 0:255;
list_len = length(list);
pos = 0;
skip = 0;
for r=1:64
    for i=1:length(lengths)
        len = lengths(i);
        % reverse
        rev_ind = mod(pos:pos+len-1,list_len)+1;
        list(rev_ind) = list(rev_ind(end:-1:1));
        % move position
        pos = mod(pos + len + skip,list_len);
        % inc skip
        skip = skip + 1;
    end
end
list(1)*list(2)

sparse_hash = list;
dense_hash = zeros(1,16);
for i=0:15
    block = sparse_hash(1+i*16:(1+i)*16);
    res = bitxor(block(1),block(2));
    for j=3:16
        res = bitxor(res,block(j));
    end
    dense_hash(i+1) = res;
end

hex_res = dec2hex(dense_hash);
reshape(hex_res.',1,[])