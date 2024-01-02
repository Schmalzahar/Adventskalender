map = char(readlines('a13.txt'));
dirs = {'^','>','v','<'};
dir_moves = [-1;height(map);1;-height(map)];
repl_with = {'|','-','|','-'};
curves_dir = [-1 1];
curves = {'\','/'};
trains = find(ismember(map,[dirs{:}]));
% the trains are given in linear indices, which is already the correct
% order in which they move
% each train has a memory of directions. First left, the staight and then
% right. At the start the first turn is left
train_nextTurn = -ones(height(trains),1);
% directions: up, right, down, left: 1,2,3,4
train_dir = NaN(height(trains),1);
trains_left = 3;
loop1 = [];
loop2 = [];
loop3 = [];
while true
    for i = 1:height(trains)
        train = trains(i);
        switch map(train)
            case '+'
                train_dir(i) = mod(train_dir(i)-1+train_nextTurn(i),4)+1;
                train_nextTurn(i) = mod(train_nextTurn(i)+2,3)-1;
            % case {'-','|'}
            %     trains(i) = train + dir_moves(train_dir(i));
            case curves
                if mod(train_dir(i),2) == 0
                    curves_dir_ = flip(curves_dir);
                else
                    curves_dir_ = curves_dir;
                end
                train_dir(i) = mod(train_dir(i)-1+ curves_dir_(map(train) == [curves{:}]),4)+1;
            case dirs
                train_dir(i) = find(map(train) == [dirs{:}]);
                map(train) = repl_with{map(train) == [dirs{:}]};
        end
        trains(i) = train + dir_moves(train_dir(i));
    end
    % sort trains (not relevant?)
    % [trains, I] = sort(trains); 
    % train_nextTurn = train_nextTurn(I);
    % train_dir = train_dir(I);
    if length(unique(trains)) < length(trains)
        % part 2: remove the crashing trains
        switch 2
            case 1
                break
            case 2
                while true
                    [crash,num] = mode(trains,'all');
                    if num == 1
                        break
                    end
                    rm_ind = trains == crash;
                    trains(rm_ind) = [];
                    train_nextTurn(rm_ind) = [];
                    train_dir(rm_ind) = [];
                end

        end
    end
    if length(trains) <= 3
        % create a list for each train position
    
            % if ~any(trains(1) == loop1)
            loop1(end+1,1) = trains(1);
            % else
            %     trains_left = trains_left - 1;
            % end
            % if ~any(trains(2) == loop2)
            loop2(end+1,1) = trains(2);
            % else
            %     trains_left = trains_left - 1;
            % end
            % if ~any(trains(3) == loop3)
            loop3(end+1,1) = trains(3);
            % else
            %     trains_left = trains_left - 1;
            % end                      
        % end
    end
    if length(loop3) == 50000
        break
    end
    % if trains_left == 0
    %     break
    % end
    % length(trains)
    % % % plot map
    % pl_map = string(map);
    % pl_map = pl_map.replace([" ","-","|","/","\","+"],["0","1","1","1","1","2"]);
    % pl_map = char(pl_map)-'0';
    % pl_map(trains) = '3';
    % colormap jet
    % imagesc(pl_map,[0 3])
end
[c,r] = ind2sub(size(map),mode(trains));
sprintf('%d,%d',r(1)-1,c(1)-1)
%%
pl_map = string(map);
pl_map = pl_map.replace([" ","-","|","/","\","+"],["0","1","1","1","1","2"]);
pl_map = char(pl_map)-'0';
% pl_map(trains) = '3';
pl_map(unique(loop1)) = 6;
% pl_map(unique(loop2)) = 4;
% pl_map(unique(loop3)) = 5;
% pl_map(unique(loop1(ismember(loop1,loop3)))) = 7;
colormap jet
imagesc(pl_map,[0 7])