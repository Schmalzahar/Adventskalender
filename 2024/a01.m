s = sort(readmatrix("a01.txt"));
part_1 = sum(abs(diff(s,1,2)))
part_2 = sum(s(:,1).*sum(s(:,1) == s(:,2)',2))