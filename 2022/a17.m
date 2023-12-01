%% Day 17

jet = char(readlines("a17.txt"));

tic
rock1 = [1 1 1 1];
rock2 = [0 1 0; 1 1 1; 0 1 0];
rock3 = [0 0 1; 0 0 1; 1 1 1];
rock4 = [1; 1; 1; 1];
rock5 = [1 1;1 1];
rocks = {rock1, rock2, rock3, rock4, rock5};
cave = zeros(3,7);
rock_num = 5000;
heights = zeros(rock_num,1);
removed_height = 0;
jet_i = 1;
rock_i = 1;
infos = cell(rock_num,4);
one_infos = {};
for i=1:rock_num
    % insert rock
    rock = rocks{rock_i};
    
    h = height(rock);
    empty_space = zeros(h,7);
    empty_space(:,3:(2+width(rock))) = rock;
    temp_cave = cat(1,empty_space,cave);
    % rock linear indices
    cave = cat(1,zeros(h,7), cave);
    [temp_row, temp_col] = ind2sub([4,7],find(temp_cave(1:4,:)));
    rock_inds = sub2ind(size(cave),temp_row, temp_col);
    lspace = 2; rspace = 7 - 2 - width(rock);
    while true
        % push
        dir = jet(jet_i);
        jet_i = mod(jet_i,length(jet))+1;
        if dir == '<' && lspace > 0
            new_rock_inds = rock_inds - height(cave);
            if ~any(cave(new_rock_inds))
                rock_inds = new_rock_inds;
                rspace = rspace + 1;
                lspace = lspace - 1;
            end
        elseif dir == '>' && rspace > 0            
            new_rock_inds = rock_inds + height(cave);
            if ~any(cave(new_rock_inds))
                rock_inds = new_rock_inds;
                rspace = rspace - 1;
                lspace = lspace + 1;
            end
        end
        % fall
        if any(mod(rock_inds,height(cave)) == 0)
            cave(rock_inds) = 1;
            break
        end
        new_rock_inds = rock_inds + 1;
        if ~any(cave(new_rock_inds))
            rock_inds = new_rock_inds;
        else
            cave(rock_inds) = 1;
            break
        end
    end
    % trim the top so that there are three empty rows
    while ~any(cave(1,:))
        cave = cave(2:end,:);
    end
    heights(i) = height(cave) + removed_height;
    
%     cave
%     if mod(i,700) == 0
%         removed_height = removed_height + height(cave) - 500;
%         cave = cave(1:500,:);
%     end
    infos(i,:) = {i,rock_i,jet_i,height(cave)};
    % check if rock_i and jet_i is already a known match
    if i>1 && ismember([rock_i jet_i],[infos{1:i-1,2};infos{1:i-1,3}]','rows')
        % loop found
        %
        ind = find(ismember([infos{1:i-1,2};infos{1:i-1,3}]',[rock_i jet_i],'rows'));
        rocks_till_pattern_start = infos{ind,1};
        height_till_pattern_start = infos{ind,4};
        pattern_height = infos{i,4}-infos{ind,4};
        pattern_rock_length = i-ind;
        
        pattern = [infos{ind:i-1,4}]-infos{ind,4};

        remain = mod((1000000000000 -rocks_till_pattern_start),pattern_rock_length);
        ans = height_till_pattern_start + floor((1000000000000 -rocks_till_pattern_start)/pattern_rock_length) * pattern_height + pattern(remain);
        sprintf('%.12e',ans)
        break
    end
    if rock_i == 1
        one_infos(end+1,:) = {i,rock_i,jet_i,height(cave)};
    end
    rock_i = mod(rock_i,length(rocks))+1;
    cave = cat(1,zeros(3,7),cave);
    
end
while ~any(cave(1,:))
    cave = cave(2:end,:);
end
toc
% height(cave)+removed_height
