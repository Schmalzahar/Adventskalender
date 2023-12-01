%% Day 25
in = fileread("input_a25.txt");
in_spl = strtrim(strsplit(in,newline));
size_1 = length(in_spl{1});
size_2 = width(in_spl);
% as matrix, empty: 0, east: 1, south: 2
in_1 = join(strtrim(strsplit(strrep(strrep(strrep(in,'.','0'),'>','1'),'v','2'),newline)),'');
mat = reshape(in_1{:},size_1,size_2)'-'0';
n=1;
while true
    old_mat = mat;
    free_ind = mat == 0;
    east_ind = mat == 1;
    south_ind = mat == 2;
    % first: east
    east_of_east_ind = circshift(east_ind,1,2);
    east_moves = east_of_east_ind & free_ind;
    % make the move
    mat(east_moves) = 1;
    mat(circshift(east_moves,-1,2)) = 0;    
    % second: south
    free_ind = mat == 0;    
    south_of_south_ind = circshift(south_ind,1,1);
    south_moves = south_of_south_ind & free_ind;
    % make the move
    mat(south_moves) = 2;
    mat(circshift(south_moves,-1,1)) = 0;
    if all(old_mat == mat,"all")
        n
        break
    end
    n = n+1;
end
