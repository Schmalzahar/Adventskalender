%% Day 9
% 8:19-8:39 part 1
% 8:39-10:05 part 2
a = readlines("a09.txt");
tic
head = [0,0]; % x, y
tail_positions = zeros(50000,2);
knot_count = 9;% set to 1 for part 1
previous_knots = zeros(knot_count+1,2);
new_knots = zeros(knot_count+1,2);
j = 2;
for i=1:height(a)
    line = strsplit(a(i),' ');
    direction = line(1,1);
    amount = str2double(line(1,2));
    for k=1:amount
        previous_knots(1,:) = head;
        switch direction
            case "U"   
                head(2) = head(2)+1;
            case "D"
                head(2) = head(2)-1;
            case "L"
                head(1) = head(1)-1;
            case "R"
                head(1) = head(1)+1;
        end
        new_knots(1,:) = head;
        for m=1:knot_count
            if all(abs(previous_knots(m+1,:) - new_knots(m,:))>0) && max(abs(previous_knots(m+1,:) - new_knots(m,:))) > 1
                % move diagonaly
                new_knots(m+1,:) = sign(new_knots(m,:)-previous_knots(m+1,:)) + previous_knots(m+1,:);
            elseif max(abs(previous_knots(m+1,:) - new_knots(m,:))) > 1
                % move normally
                new_knots(m+1,:) = previous_knots(m+1,:) + (previous_knots(m+1,:) - new_knots(m,:))/(-2);                
            else
                break
            end
            tail_positions(j,:) = new_knots(end,:);
            j = j+1;
        end
        previous_knots = new_knots;       
    end         
end
toc
length(unique(tail_positions,'rows'))