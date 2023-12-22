input = char(readlines('a16.txt'));
dir_map = ones(size(input));
%dirs: 2: right, 3:down, 5: left, 7: up
dirs = [2 3 5 7];
tic
max_energy = 0;
for i=1:height(dir_map)
    %left edge, dir right
    dir_map = ones(size(input));
    [dir_map] = light_beam(input, dir_map, i, dirs(1), dirs);
    energy = sum(dir_map>1,'all');
    if energy > max_energy
        max_energy = energy;
    end
    %right edge, dir left
    dir_map = ones(size(input));
    [dir_map] = light_beam(input, dir_map, i+(width(input)-1)*height(input), dirs(3), dirs);
    energy = sum(dir_map>1,'all');
    if energy > max_energy
        max_energy = energy;
    end
end

for j=1:width(dir_map)
    %top edge, dir down
    dir_map = ones(size(input));
    [dir_map] = light_beam(input, dir_map, 1+(j-1)*height(input), dirs(2), dirs);
    energy = sum(dir_map>1,'all');
    if energy > max_energy
        max_energy = energy;
    end
    %bottom edge, dir up
    dir_map = ones(size(input));
    [dir_map] = light_beam(input, dir_map, (j)*height(input), dirs(4), dirs);
    energy = sum(dir_map>1,'all');
    if energy > max_energy
        max_energy = energy;
    end
end

max_energy
toc
function dir_map = light_beam(grid, dir_map, beam_loc, beam_dir, dirs)
    if beam_loc == 0
        return
    end
    if mod(dir_map(beam_loc), beam_dir) ~= 0
        dir_map(beam_loc) = beam_dir;
    else
        return
    end

    switch  grid(beam_loc) 
        case '|' 
            if ismember(beam_dir, [dirs(1), dirs(3)])
                %split up down
                new_dir_1 = dirs(2);
                new_dir_2 = dirs(4);
                new_loc_1 = NL(beam_loc, new_dir_1, size(grid), dirs);
                new_loc_2 = NL(beam_loc, new_dir_2, size(grid), dirs);
                [dir_map] = light_beam(grid, dir_map, new_loc_1, new_dir_1, dirs);
                [dir_map] = light_beam(grid, dir_map, new_loc_2, new_dir_2, dirs);
            else
                new_loc = NL(beam_loc, beam_dir, size(grid), dirs);
                [dir_map] = light_beam(grid, dir_map, new_loc, beam_dir, dirs);
            end
        case '-' 
            if ismember(beam_dir, [dirs(2), dirs(4)])
                %split left right
                new_dir_1 = dirs(1);
                new_dir_2 = dirs(3);
                new_loc_1 = NL(beam_loc, new_dir_1, size(grid), dirs);
                new_loc_2 = NL(beam_loc, new_dir_2, size(grid), dirs);
                [dir_map] = light_beam(grid, dir_map, new_loc_1, new_dir_1, dirs);
                [dir_map] = light_beam(grid, dir_map, new_loc_2, new_dir_2, dirs); 
            else
                new_loc = NL(beam_loc, beam_dir, size(grid), dirs);
                [dir_map] = light_beam(grid, dir_map, new_loc, beam_dir, dirs);
            end
        case '/'
            switch beam_dir
                case dirs(1)
                    new_dir = dirs(4);
                case dirs(2)
                    new_dir = dirs(3);
                case dirs(3)
                    new_dir = dirs(2);
                case dirs(4)
                    new_dir = dirs(1);
            end
            new_loc = NL(beam_loc, new_dir, size(grid), dirs);
            [dir_map] = light_beam(grid, dir_map, new_loc, new_dir, dirs);
        case '\'
            switch beam_dir
                case dirs(1)
                    new_dir = dirs(2);
                case dirs(2)
                    new_dir = dirs(1);
                case dirs(3)
                    new_dir = dirs(4);
                case dirs(4)
                    new_dir = dirs(3);
            end
            new_loc = NL(beam_loc, new_dir, size(grid), dirs);
            [dir_map] = light_beam(grid, dir_map, new_loc, new_dir, dirs);
        otherwise
            new_loc = NL(beam_loc, beam_dir, size(grid), dirs);
            [dir_map] = light_beam(grid, dir_map, new_loc, beam_dir, dirs);
    end
end

function new_loc = NL(old_loc, beam_dir,sz, dirs)
    switch beam_dir
        case dirs(1)
            new_loc = old_loc + sz(1);
            if new_loc > sz(1)*sz(2)
                new_loc = 0;
            end
        case dirs(2)
            new_loc = old_loc + 1;
            if new_loc > floor((old_loc-0.0001)/sz(1)+1)*sz(1)
                new_loc = 0;
            end
        case dirs(3)
            new_loc = old_loc - sz(1);
            if new_loc < 1
                new_loc = 0;
            end
        case dirs(4)
            new_loc = old_loc - 1;
            if new_loc < floor((old_loc-0.0001)/sz(1))*sz(1)+1
                new_loc = 0;
            end
    end
end