input = readlines("a09.txt").split(';');
player_num = input(1).extract(digitsPattern).double;
maxMarb = input(2).extract(digitsPattern).double;

tic
score = dictionary;
% part 2:
maxMarb = maxMarb * 100;

circle = NaN(maxMarb,2); % prev,next
prev = 1; next = 2;
% init the circle
circle(2,prev) = 1; circle(2,next) = 1;
circle(1,prev) = 2; circle(1,next) = 2;
head = 2;

for marble=2:(maxMarb+1)
    if mod(marble,23) == 0
        head = circle(circle(circle(circle(circle(circle(circle(head,prev),prev),prev),prev),prev),prev),prev);
        if ~score.isConfigured || ~isKey(score,mod(marble, player_num))
            score(mod(marble, player_num)) = marble + head-1;
        else
            score(mod(marble, player_num)) = ...
                score(mod(marble, player_num)) + marble + head-1;
        end
        % remove marble
        circle(circle(head,next),prev) = circle(head,prev);
        circle(circle(head,prev),next) = circle(head,next);
        head = circle(head,next);
    else
        % insert in the next marble, relative to head
        head = circle(head,next);
        % insert between this and next
        circle(marble+1,prev) = head;
        circle(marble+1,next) = circle(head,next);
        circle(circle(head,next),prev) = marble+1;
        circle(head,next) = marble+1;     
        head = marble+1;
    end
end
format long
max(score.values)
toc