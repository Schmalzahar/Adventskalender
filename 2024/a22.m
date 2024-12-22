res = double(readlines("a22.txt"));
tic
rounds = 2000;
prices = zeros(size(res,1), rounds);
for i=1:rounds
    res = secret(res);    
    prices(:,i) = mod(res, 10);
end

int64(sum(res))

diffs = diff(prices,1,2);

seqs = arrayfun(@(i) diffs(:, i:i+3), 1:size(diffs, 2)-3, 'UniformOutput', false);
seqs = cat(3, seqs{:}) + 10; % so it is between 1 and 19

zcache = zeros(19,19,19,19);

lastSeen = NaN(19,19,19,19);

for h=1:size(res,1) 
    for w=1:size(seqs,3)
        if lastSeen(seqs(h,1,w), seqs(h,2,w), seqs(h,3,w),seqs(h,4,w)) == h
            continue
        end
        lastSeen(seqs(h,1,w), seqs(h,2,w), seqs(h,3,w),seqs(h,4,w)) = h;
        zcache(seqs(h,1,w), seqs(h,2,w) , seqs(h,3,w),seqs(h,4,w)) = zcache(seqs(h,1,w), seqs(h,2,w), seqs(h,3,w),seqs(h,4,w)) + prices(h,w+4);
    end
end

max(zcache,[],'all')
toc

function res = secret(in)
    res = mod(bitxor(in, in * 64), 16777216);
    res = mod(bitxor(floor(res/32), res), 16777216);
    res = mod(bitxor(res * 2048, res), 16777216);
end