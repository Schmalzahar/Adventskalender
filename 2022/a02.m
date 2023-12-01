%% Day 2
% 10:00-10:14 part 1
% 10:14-10:19 part 2
rounds = readlines("a02.txt");
total_score = 0;
part = 2;
options = 'ABC';
for i=1:height(rounds)
    round = char(rounds(i));
    if part == 1
        player2 = char(round(3)-23); % convert X to A, Y to B and Z to C
    elseif part == 2
        new_options = circshift(options,-round(1)+2); % shift so that player1 is at front
        player2 = circshift(new_options,-round(3)+2); % shift so that player2 is at front
        player2 = player2(1);
    end    
    score = player2-64; % shape score
    player1 = round(1);
    if player1 == player2
        score = score + 3; % draw
    elseif player1-player2 == -1 || player1-player2 == 2
        score = score + 6; % win
    end
    total_score = total_score + score;
end
disp("Total score: "+double(total_score))