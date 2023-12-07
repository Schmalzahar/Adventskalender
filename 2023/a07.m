remaining = readlines("a07.txt").split(' ');
remaining(:,1) = rename(remaining(:,1));
sorted = [];
sums = [25 17 13 11 9 7 5];
for s = sums
    type_idx = find(arrayfun(@(x) funsum(x,s), remaining(:,1)));
    sorted = [sorted; sortrows(remaining(type_idx,:),'descend')];
    remaining = remaining(setdiff((1:end),type_idx),:);
end
sum(sorted(:,2).double .* (size(sorted,1):-1:1)')

function out = rename(input)
% in order to be able to sort them easily, replace the names of Ace with
% Ten. ALso replace K with Q
    out = input.replace('A','r').replace('T','A').replace('r','T');
    out = out.replace('K','r').replace('Q','K').replace('r','Q');  
    % part 2
    out = out.replace('J','1');  
end

function out = funsum(input,s)
    t = char(input);
    % part 2: 1 is now the joker
    if any(t == '1') && (~all(t == '1'))
        % the joker always becomes the most common card
        most_common = mode(t(t~='1'));
        t(t=='1')=most_common;
    end
    out = sum(t==t','all') == s;
end