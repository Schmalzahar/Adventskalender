input = char(readlines("a14.txt"));
tic
load = 0;
all_cyls = dictionary;
cyl = 1;
while true
    for d = 1:4
        for i=1:size(input,2)
            input(:,i) = cell2mat(join(cellfun(@(x) sort(x, 'descend'),split(join(input(:,i)',''),'#'),'UniformOutput',false),'#'));
        end   
        input = rot90(input,-1);
    end    
    load = sum(sum(input == 'O',2) .* (height(input):-1:1)');
    if ~isConfigured(all_cyls) || ~isKey(all_cyls, {input})
        all_cyls{{input}} = [load cyl];
    else
        cycle_start_dur = all_cyls{{input}}(2) - 1;
        cycle_len = cyl - all_cyls{{input}}(2);
        break
    end
    cyl = cyl + 1;
end
% load
cyl_vals = values(all_cyls);
cyl_vals{mod(10^9-cycle_start_dur,cycle_len)+cycle_start_dur}(1)
toc