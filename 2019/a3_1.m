data = readlines("input_3.txt");
tic
cable1 = mapCable(data(1));
cable2 = mapCable(data(2));
matchmat = sparse(height(cable1),height(cable2));
for i=1:height(cable1)
    id = find(all(cable1(i,:) == cable2,2));
    matchmat(i,id) = 1;
end
[a,b] = find(matchmat);
a = a(2:end); b = b(2:end);
res1 = min(abs(cable1(a,1)) + abs(cable1(a,2)))
res2 = min(a+b-2)
toc

function cable1 = mapCable(data)
    cable1 = [0 0];
    ds = strsplit(data,',');
    for i=ds
        ii = char(i);
        switch ii(1)
            case 'R'                
                new_cable = [1:str2double(ii(2:end)); repelem(0,str2double(ii(2:end)))]';
            case 'U'
                new_cable = [repelem(0,str2double(ii(2:end))); 1:str2double(ii(2:end))]';
            case 'L'
                new_cable = [-1:-1:-str2double(ii(2:end)); repelem(0,str2double(ii(2:end)))]';
            case 'D'
                new_cable = [repelem(0,str2double(ii(2:end))); -1:-1:-str2double(ii(2:end))]';
        end
        cable1 = cat(1,cable1, new_cable + cable1(end,:));
    end
end