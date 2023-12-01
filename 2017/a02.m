in = readmatrix("a02.txt");
sum(max(in,[],2)-min(in,[],2))
%% part 2
tic
while true
    res = in./min(in,[],2);
    res1 = res.*arrayfun(@(x) round(x) == x,res);
    % Set those entries in the rows who only have a 1 to NaN
    res1_ind = sum(res1,2,'omitnan')==1 & res1 == 1;
    if sum(res1_ind,'all') == 0
        break
    end
    in(res1_ind) = NaN;
end
sum(res1(res1~=1),'omitnan')
toc