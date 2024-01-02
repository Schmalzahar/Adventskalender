input = readlines("a09.txt").split(';');
player_num = input(1).extract(digitsPattern).double;
maxMarb = input(2).extract(digitsPattern).double;
score = zeros(player_num,maxMarb);
max_score = zeros(maxMarb,1);
curr_max = 0;
current_marble = 0;
current_marble_idx = 1;
circle = 0;
while true    
    if mod(current_marble+1,23) == 0
        curr_player = mod(current_marble,player_num)+1;
        score(curr_player,current_marble) = max(score(curr_player,:)) + current_marble+1;
        circle_seven_sh = circshift(1:length(circle),7);
        % current_ind = find(circle == current_marble);
        sh_ind = circle_seven_sh(current_marble_idx);
        score(curr_player,current_marble) = score(curr_player,current_marble) + circle(sh_ind);
        if score(curr_player,current_marble) > curr_max
            curr_max = score(curr_player,current_marble);
        end
        circle(sh_ind) = [];
        new_circle = circle;
        current_marble = current_marble + 1;
        current_marble_idx = sh_ind;
    else
        circle_inds_shift = circshift(1:length(circle),-1);
        % current_ind = find(circle == current_marble);
        sh_ind = circle_inds_shift(current_marble_idx);
        new_circle = [circle(1:sh_ind) (current_marble+1) circle(sh_ind+1:end)];
        current_marble = current_marble + 1;
        current_marble_idx = sh_ind + 1;
    end
    circle = new_circle;
    if current_marble == maxMarb
        break
    end

    max_score(current_marble) = curr_max;

end
max(score,[],"all")