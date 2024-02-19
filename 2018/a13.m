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
loop1 = []; loop1_size = 0;
loop2 = []; loop2_size = 0;
loop3 = []; loop3_size = 0;
tick = 1;
while true
    prev_trains = trains;
    for i = 1:height(trains)
        train = trains(i);
        if train == 0
            continue
        end
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
        % collision?
        if length(unique(trains)) < length(trains)
            switch 2
                case 1
                    break
                case 2
                    while true
                        [crash,num] = mode(trains,'all');
                        if num == 1 || crash == 0
                            break
                        end
                        rm_ind = trains == crash;
                        [c,r] = ind2sub(size(map),mode(trains(rm_ind)));
                        fprintf("Crash at %d,%d on tick %d.\n",r(1)-1,c(1)-1,tick)
                        trains(rm_ind) = 0;
                        train_nextTurn(rm_ind) = 0;
                        train_dir(rm_ind) = 0;
                    end
    
            end
        end
    end
    if any(trains == 0)
        rm_ind = trains == 0;
        trains(rm_ind) = [];
        train_nextTurn(rm_ind) = [];
        train_dir(rm_ind) = [];
    end
    if tick == 476
        test = 1;
    end
    % sort trains
    [trains, I] = sort(trains); 
    train_nextTurn = train_nextTurn(I);
    train_dir = train_dir(I);

    if length(trains) == 1
        break
    end
    tick = tick + 1;
end
[c,r] = ind2sub(size(map),mode(trains));
sprintf('%d,%d',r(1)-1,c(1)-1)