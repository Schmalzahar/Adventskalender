input = readlines("a15.txt")
a = find(input == "");
map = char(input(1:a-1)); moves = char(input(a+1:end));


%% part 2
wide_map = char(zeros([size(map,1) 2*size(map,2)]));
for ix = 1:size(map,1)
    for iy = 1:size(map,2)
        switch map(ix, iy)
            case '#'
                wide_map(ix, 2*iy-1:2*iy) = '#';
            case '.'
                wide_map(ix, 2*iy-1:2*iy) = '.';
            case 'O'
                wide_map(ix, 2*iy-1:2*iy) = '[]';
            case '@'
                wide_map(ix, 2*iy-1:2*iy) = '@.';
        end
    end
end

map = wide_map;


%%



[robotx, roboty] = find(map == '@');

for ix=1:size(moves,1)
    for iy=1:size(moves,2)

        move = moves(ix, iy);
        fl = 0;
        line = getLine(map, robotx, roboty, move);

        switch line(1)
            case '.'
                line(1) = '@';
                map(robotx, roboty) = '.';                
                map = setLine(map, robotx, roboty, move, line);
                [robotx, roboty] = robotMoved(robotx, roboty, move);
            case '#'
                continue
            case 'O'
                space = find(line == '.',1);
                walls = find(line == '#',1);
                if space < walls
                    block_moving = line(1:space-1);
                    line(2:space) = block_moving;
                    line(1) = '@';
                    map(robotx, roboty) = '.';
                    map = setLine(map, robotx, roboty, move, line);
                    [robotx, roboty] = robotMoved(robotx, roboty, move);
                end
            case {'[',']'}
                if  ismember(move,['>','<'])
                    space = find(line == '.',1);
                    walls = find(line == '#',1);
                    if space < walls
                        block_moving = line(1:space-1);
                        line(2:space) = block_moving;
                        line(1) = '@';
                        map(robotx, roboty) = '.';
                        map = setLine(map, robotx, roboty, move, line);
                        [robotx, roboty] = robotMoved(robotx, roboty, move);
                    end
                else
                    if move == '^'
                        %index_list keeps track of the [ brackets.
                        % index_list = sub2ind(size(map),robotx-1, roboty);
                        if line(1) == '['
                            index_list = sub2ind(size(map),robotx-1, roboty);
                        else
                            index_list = sub2ind(size(map),robotx-1, roboty-1);
                        end
                        to_move = true;
                        move_up_idx = index_list;
                        while to_move

                            index_list_up = move_up_idx-1;
                            move_up_idx = [];
                            for j=1:size(index_list_up,2)
                                block = [index_list_up(j) index_list_up(j)+size(map,1)];
                                if ismember('#',map(block))
                                    to_move = false;
                                    break
                                end
                                if all(map(block) == '[]')
                                    move_up_idx = [move_up_idx block(1)]; 
                                end
 
                                if map(block(1)) == ']'
                                    move_up_idx = [move_up_idx block(1)-size(map,1)];
                                    % move_up_idx = [move_up_idx block(2)];
                                end
                                if map(block(2)) == '['
                                    move_up_idx = [move_up_idx block(2)];
                                end  
                            end
                            if isempty(move_up_idx)
                                break
                            end
                            index_list = [index_list move_up_idx];
                        end
                        if to_move
                            temp_map = map;
                            map(index_list) = '.';
                            map(index_list+size(map,1)) = '.';
                            map(index_list-1) = '[';
                            map(index_list-1+size(map,1)) = ']';
                            map(robotx, roboty) = '.';
                            [robotx, roboty] = robotMoved(robotx, roboty, move);
                            map(robotx, roboty) = '@';
                        end
                            
                    else
                        %index_list keeps track of the [ brackets.
                        % index_list = sub2ind(size(map),robotx-1, roboty);
                        if line(1) == '['
                            index_list = sub2ind(size(map),robotx+1, roboty);
                        else
                            index_list = sub2ind(size(map),robotx+1, roboty-1);
                        end
                        to_move = true;
                        move_up_idx = index_list;
                        while to_move

                            index_list_up = move_up_idx+1;
                            move_up_idx = [];
                            for j=1:size(index_list_up,2)
                                block = [index_list_up(j) index_list_up(j)+size(map,1)];
                                if ismember('#',map(block))
                                    to_move = false;
                                    break
                                end
                                if all(map(block) == '[]')
                                    move_up_idx = [move_up_idx block(1)]; 
                                end
                                if map(block(1)) == ']'
                                    move_up_idx = [move_up_idx block(1)-size(map,1)];
                                    % move_up_idx = [move_up_idx block(2)];
                                end
                                if map(block(2)) == '['
                                    move_up_idx = [move_up_idx block(2)];
                                end                                
                            end
                            if isempty(move_up_idx)
                                break
                            end
                            index_list = [index_list move_up_idx];
                        end
                        if to_move
                            temp_map = map;
                            map(index_list) = '.';
                            map(index_list+size(map,1)) = '.';
                            map(index_list+1) = '[';
                            map(index_list+1+size(map,1)) = ']';
                            map(robotx, roboty) = '.';
                            [robotx, roboty] = robotMoved(robotx, roboty, move);
                            map(robotx, roboty) = '@';
                        end
                    end
                end
        end
        
        % map
    end
end

[boxx, boxy] = find(map == 'O');
part1 = sum((boxx-1)*100+(boxy-1))
%%
% part 2 calc
[boxx, boxy] = find(map == '[');
% part2 = 0;
% for i=1:numel(boxx)
%     if boxx(i) < size(map,1)/2
%         part2 = 100 * (boxx(i)-1) + part2;
%     else
%         part2 = 100 * (size(map,1)-boxx(i)) + part2;
%     end
%     if boxy(i) < size(map,2)/2
%         part2 = boxy(i)-1 + part2;
%     else
%         part2 = size(map,2)-boxy(i) + part2;
%     end
% end
% [t1, t2] = meshgrid([0:4 4:-1:0]*100,[0:9 9:-1:0]);
% mat = t1' + t2' 

[r,c] = find(map == '[');
part2 = sum((r-1) * 100 + c-1)

% part2


function line = getLine(map, robotx, roboty, move)
    switch move
        case '>'
            line = map(robotx, roboty+1:end);           
        case '<'
            line = fliplr(map(robotx, 1:roboty-1));
        case 'v'
            line = map(robotx+1:end, roboty)';
        case '^'
            line = fliplr(map(1:robotx-1, roboty)');
    end
end

function map = setLine(map, robotx, roboty, move, line)
    switch move
        case '>'
            map(robotx, roboty+1:end) = line;
        case '<'
            map(robotx, 1:roboty-1) = fliplr(line);
        case 'v'
            map(robotx+1:end, roboty) = line';
        case '^'
            map(1:robotx-1, roboty) = fliplr(line)';
    end
end

function [robotx, roboty] = robotMoved(robotx, roboty, move)
    switch move
        case '>'
            roboty = roboty + 1;
        case '<'
            roboty = roboty - 1;
        case 'v'
            robotx = robotx + 1;
        case '^'
            robotx = robotx - 1;
    end
end





