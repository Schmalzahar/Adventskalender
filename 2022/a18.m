 input = readlines("a18.txt");
 input = sortrows(input.split(',').double);
 neigh = 0;

 sides = @(x) [[x(1)+1,x(2),x(3)];[x(1)-1,x(2),x(3)];[x(1),x(2)+1,x(3)];[x(1),x(2)-1,x(3)];[x(1),x(2),x(3)+1];[x(1),x(2),x(3)-1]];
a = 0;
 for i=1:height(input)
    in = input(i,:);
     dist = sum(abs(in-input),2);
     neigh = neigh + sum(dist == 1);

     % alternative
    s = sides(in);
    for ss = 1:height(s)
        sss = s(ss,:);
        if ~ismember(sss,input,"rows")
            a = a+1;
        end
    end

 end
a
height(input) * 6 - neigh


%% part 2

seen = [];
todo = [-1 -1 -1];
while ~isempty(todo)
    here = todo(end,:); todo(end,:) = [];

    temp = sides(here);
    temp = temp(~ismember(temp,input,'rows'),:);
    if ~isempty(seen)
        temp = temp(~ismember(temp,seen,'rows'),:);
    end
    for tt=1:height(temp)
        t = temp(tt,:);
        if all(-1 <= t & t <= 25)
            todo = [todo; t];
        end
    end
    seen(end+1,:) = here;
end
%%
seen = unique(seen,"rows");
final_res = 0;
 for i=1:height(input)
     in = input(i,:);
     s = sides(in);
     for ss = 1:height(s)
        sss = s(ss,:);
        if ismember(sss,seen,"rows")
            final_res = final_res + 1;
        end
     end
 end
 final_res
