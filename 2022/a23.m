%% Day 23
% part 1: 11:39-12:31
% part 2: 12:31-

elves = char(strrep(strrep(readlines("a23.txt"),'.','0'),'#','1'))-'0';
order = ['N','S','W','E'];
% get elves coordinates
el = find(elves);
% for round = 1:10
round = 1;
while true
    % adjust elves coordinates
    [r,c] = ind2sub(size(elves),el);
    % pad in each direction by 1
    new_elves = zeros(size(elves)+2);   
    new_elves(2:end-1,2:end-1) = elves;
    elves = new_elves;
    el = sub2ind(size(elves),r+1,c+1);
    % first half
    prop_el = zeros(size(el));
    skipped = 0;
    for e = 1:numel(el)
        % get surrounding values
        dummy_mat = zeros(size(elves));
        dummy_mat(el(e)) = 1;
        surrounding_indices = find(conv2(dummy_mat,[1,1,1;1,0,1;1,1,1],'same'));
        surrounding_values = elves(surrounding_indices);
        if ~all(surrounding_values == 0)
            for or = order
                switch or
                    case 'N'
                        sur = [surrounding_values(1),surrounding_values(4),surrounding_values(6)];
                        if all(sur == 0)
                            prop_el(e) = el(e) - 1;
                            break
                        end
                    case 'S'
                        sur = [surrounding_values(3),surrounding_values(5),surrounding_values(8)];
                        if all(sur == 0)
                            prop_el(e) = el(e) + 1;
                            break
                        end
                    case 'W'
                        sur = [surrounding_values(1),surrounding_values(2),surrounding_values(3)];
                        if all(sur == 0)
                            prop_el(e) = el(e) - height(elves);
                            break
                        end
                    case 'E'
                        sur = [surrounding_values(6),surrounding_values(7),surrounding_values(8)];
                        if all(sur == 0)
                            prop_el(e) = el(e) + height(elves);
                            break
                        end
                end
            end
        else
            skipped = skipped + 1;
        end
        

        
    end
    round = round + 1;
    
    if skipped == length(el)
        break
    end
    % make the possible moves
    new_el = zeros(size(prop_el));
    in1 = grouptransform(prop_el,prop_el,@numel) == 1;
    new_el(in1) = prop_el(in1);
    new_el(~in1) = el(~in1);
    new_elves = zeros(size(elves));
    new_elves(new_el) = 1;
    elves = new_elves;                                                                                                                                                                                                                          
    el = new_el;
    order = [order(2:end),order(1)];
    if mod(round,4) == 0
        % trim elves
        [r,c] = ind2sub(size(elves),el);
        elves = elves(min(r):max(r),min(c):max(c));
        el = sub2ind(size(elves),r-min(r)+1,c-min(c)+1);
    end
end

% count the empty grounds in the rectangle
[r,c] = ind2sub(size(elves),el);
h = max(r) - min(r) + 1;
w = max(c) - min(c) + 1;
elves(min(r):max(r),min(c):max(c))
result = h*w - numel(el)