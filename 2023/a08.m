input = readlines("a08.txt");
tic
d = char(input(1));
starts = input(3:end).extractBefore(" ");
m = dictionary(reshape(starts'+["L";"R"],[],1),...
    reshape(input(3:end).extractBetween("(",")").split(", ")',[],1));
elements = starts(starts.extract(3) == "A");
global_steps = nan(1,numel(elements));
step = 1;
while any(isnan(global_steps))
    elements = m(elements+d(1));
    global_steps(elements.extract(3) == "Z") = step;
    step = step + 1;
    d = circshift(d,-1);
end
eval_str = '';
for i=1:size(global_steps,2)-1
    eval_str = [eval_str,'lcm(',num2str(global_steps(i)),','];
end
eval_str = [eval_str,num2str(global_steps(end)),repelem(')',size(global_steps,2)-1)];
format long
eval(eval_str)
toc