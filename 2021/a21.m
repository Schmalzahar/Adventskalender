%% Day 21
tic
sp1 = 3;
sp2 = 7;
p1s = 0;
p2s = 0;
% deterministic dice: first roll: 1, second: 2, 100-th: 100, 101-th: 1, ...
die = 100; % start at 100 so the first roll will be 1
turns = 0;
while true
    turns = turns +1;
    % roll 3 times
    rolls = 0;
    for i=1:3
        die = roll(die);
        rolls = rolls + die;
    end
    if mod(turns,2) == 1
        % player 1
        sp1 = mod(sp1 + rolls-1,10)+1;
        p1s  = p1s + sp1;
    else
        % player 2
        sp2 = mod(sp2 + rolls-1,10)+1;
        p2s = p2s + sp2;
    end
    if p1s >= 1000       
        result = p2s * 3* turns
        break
    elseif p2s >= 1000
        result = p1s * 3* turns
        break
    end
end
toc
%% Part 2
state_cube = zeros([10,10,21,21]); % pos p1, pos p2, s1-1, s2-1
state_cube(3,7,1,1) = 1;
tic
x = (1:3) + (1:3)' + permute(1:3,[1,3,2]);
[d, ~, ic] = unique(x);
p = accumarray(ic, 1);
wins = [0, 0];
turn = 2;

while any(state_cube ~= 0, 'all')
  turn = 3 - turn;

  % Move
  next = zeros(size(state_cube));
  for j = 1:numel(p)
    next = next + p(j) * circshift(state_cube, d(j), turn); % add the positions
  end

  % Count Wins and Increase Score
  if turn == 2
    next = permute(next, [2,1,4,3]);
  end

  for j = 1:10
    % Count winners
    wins(turn) = wins(turn) + sum(next(j,:,end-j+1:end,:), 'all');
    % Inrease score
    next(j,:,1+j:end,:) = next(j,:,1:end-j,:);
    next(j,:,1:j,:) = 0;
  end

  if turn == 2
    next = permute(next, [2,1,4,3]);
  end

  state_cube = next;
end

ans_2 = max(wins);
fprintf('wins1: %.0f\n', wins(1));
fprintf('wins2: %.0f\n', wins(2));
toc

function res = roll(pre)
    if pre <= 99
        res = pre + 1;
    elseif pre == 100
        res = 1;
    end
end