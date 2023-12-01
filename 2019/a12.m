data = readlines("input_12.txt");
tic
moon_cords = zeros(4,3);
for i=1:4
    line = regexp(data(i),"x=(-?\d*), y=(-?\d*), z=(-?\d*)","tokens");
    moon_cords(i,:) = str2double(line{:});
end
%% Part 1
n_timesteps = 1000;
moon_vel = zeros(4,3);
combs = nchoosek(1:4,2);
moon_cords_n = moon_cords;
for n=1:n_timesteps
    for i=1:height(combs)
        moon1 = moon_cords_n(combs(i,1),:);
        moon2 = moon_cords_n(combs(i,2),:);
        % every axis
        for j=1:3
            moon_vel(combs(i,1),j) = moon_vel(combs(i,1),j) - sign(moon1(j)-moon2(j));
            moon_vel(combs(i,2),j) = moon_vel(combs(i,2),j) + sign(moon1(j)-moon2(j));
        end
    end
    % change pos accordingly
    moon_cords_n = moon_cords_n + moon_vel;
end
% total energy
tot_energy = sum(abs(moon_cords_n),2)' * sum(abs(moon_vel),2)
toc
%% Part 2
% go through each dimension and get the period
tic
periods = zeros(1,3);
for j=1:3
    n = 1;
    moon_cords_j = moon_cords(:,j);
    moon_vel = zeros(4,1);
    while true
        for i=1:height(combs)
            moon1 = moon_cords_j(combs(i,1));
            moon2 = moon_cords_j(combs(i,2));
            moon_vel(combs(i,1)) = moon_vel(combs(i,1)) - sign(moon1-moon2);
            moon_vel(combs(i,2)) = moon_vel(combs(i,2)) + sign(moon1-moon2);
        end
        moon_cords_j = moon_cords_j + moon_vel;
        if all(moon_vel==0)
            if all(moon_cords_j == moon_cords(:,j))
                periods(1,j) = n;
                break
            end
        end
        n = n+1;
    end
end
res = lcm(sym(periods))
toc