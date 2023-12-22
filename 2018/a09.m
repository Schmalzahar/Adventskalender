input = readlines("a09.txt");
player_num = input.extractBefore(' ').double;
turn = 0;
circle = [];
while true
    if isempty(circle)
        circle = 0;
        current_marble = 1;
        turn = turn + 1;
    else
        new_circle = [circle(1:current_marble+1) turn circle(current_marble+2:end)];
    end

end