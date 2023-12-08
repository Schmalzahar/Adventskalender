input = readlines("a08.txt");
tic
old_dir = char(input(1));
% build dictionary from networks
network = input(3:end);
network =  regexp(network,'(\w\w\w)','match');
network_t = table2array(cell2table(network));
starts = char(network_t(:,1));
netdict = dictionary(starts,network);
% elements = 'AAA'; % part 1
elements = starts(starts(:,3) == 'A',:); % part 2
global_steps = [];
steps = 1;
while true
    res = netdict(elements);
    res = reshape([res{:}],3,[])';
    if dir(1) == 'L'
        elements = char(res(:,2));
    else
        elements = char(res(:,3));
    end
    if any(elements(:,3) == 'Z')
        global_steps(end+1) = steps;  
        elements(elements(:,3) == 'Z',:) = [];
    end
    dir = circshift(dir,-1);
    steps = steps + 1;
    if size(global_steps,2) == 6
        break
    end
end

eval_str = '';
for i=1:size(global_steps,2)-1
    eval_str = [eval_str,'lcm(',num2str(global_steps(i)),','];
end
eval_str = [eval_str,num2str(global_steps(end)),repelem(')',size(global_steps,2)-1)];
eval(eval_str)
toc