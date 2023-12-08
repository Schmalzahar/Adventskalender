input = readlines("a08.txt");
tic
old_dir = char(input(1));
network = input(3:end);
network =  regexp(network,'(\w\w\w)','match');
network = table2array(cell2table(network));
starts = char(network(:,1));
% elements = 'AAA'; % part 1
elements = starts(starts(:,3) == 'A',:); % part 2
global_steps = zeros(size(elements,1),1);
for i=1:size(elements,1)
    steps = 1;
    element = elements(i,:);
    dir = old_dir;
    while true
        res = network(element == network(:,1),2:3);
        if dir(1) == 'L'
            element = char(res(:,1));
        else
            element = char(res(:,2));
        end
        if element(:,3) == 'Z'
            global_steps(i) = steps;
            break
        end
        dir = circshift(dir,-1);
        steps = steps + 1;
    end
end
eval_str = '';
for i=1:size(global_steps,1)-1
    eval_str = [eval_str,'lcm(',num2str(global_steps(i)),','];
end
eval_str = [eval_str,num2str(global_steps(end)),repelem(')',size(global_steps,1)-1)];
eval(eval_str)
toc