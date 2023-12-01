%% Day 11
energy_raw = readmatrix("input_a11.txt","OutputType","string");
energy = NaN(10,10);
for i=1:10
    energy(i,:) = str2double(regexp(energy_raw(i),'.','match'));
end

noOfSteps = 1000;
flashes = 0;
for j=1:noOfSteps
    energy = in(energy);
    new_flashes = energy > 9;
    flashed = false(10);
    while any(any(new_flashes))
        energy = inadj(energy,new_flashes);
        flashed = flashed | new_flashes;
        % Those that have energy>9 that are not in flashed need to flash
        all_flashes = energy > 9;
        new_flashes = flashed ~= all_flashes;
    end
    if all(all(flashed))
        disp("All flashed at step: "+j)
    end
    % Set the flashed octopuses to zero
    energy(flashed) = 0;
    % Count the flashes
    flashes = flashes + sum(sum(flashed));
end


function energy = in(energy,logarray)
    % Increase the energy of those in logarray by one
    if nargin == 1
        logarray = true(10);
    end
    energy(logarray) = energy(logarray) + 1;
end

function energy = inadj(energy,logarray)
    % Increase every adjacent energy from the log array by one. Do this for
    % every logarray entry
    while(any(any(logarray)))
        [id1,id2] = find(logarray,1,'first');
        energy = in(energy,adj(id1,id2));
        % Set the already considered entry to zero
        logarray(id1,id2) = 0;
    end
end

function logout = adj(id1,id2)
    % Get the adjacent indices of id1 and id2
    logout = false(10);
    if id1 == 1
        id1range = id1:id1+1;
    elseif id1 == 10
        id1range = id1-1:id1;
    else
        id1range = id1-1:id1+1;
    end    
    if id2 == 1
        id2range = id2:id2+1;
    elseif id2 == 10
        id2range = id2-1:id2;
    else    
        id2range = id2-1:id2+1;
    end
    logout(id1range,id2range) = 1;
    logout(id1,id2)=0;    
end