input =  readlines("a12.txt");
initialState = input(1).extractAfter(": ");
spreadInfo = input(3:end).split(" => ");
potNums = 0:(length(char(initialState))-1);
old_state = char(initialState);
for i=1:200    
    plants = find(old_state == '#');
    expanded = [repelem('.',4) old_state repelem('.',4)];
    
    new_state = repelem('.',length(expanded));
    for j=1:height(spreadInfo)
        patMat = arrayfun(@(x) all(spreadInfo(j,1) == expanded(x-2:x+2)), 3:(length(expanded)-2));
        new_state(patMat) = spreadInfo(j,2);
    end
    firstPlant = find(new_state == '#',1);
    lastPlant = find(new_state == '#',1,"last");
    potNums = [(potNums(1)-2):(potNums(1)-1) potNums (potNums(end)+1):(potNums(end)+2)];
    potNums = potNums(firstPlant:lastPlant);
    old_state = new_state(firstPlant:lastPlant);
end

plants = find(old_state == '#') + min(potNums)-1;
sum(plants)