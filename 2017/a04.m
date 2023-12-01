passphrases = readlines("a04.txt");
valid = 0;
for i=1:length(passphrases)
    phrase = split(passphrases(i));
    % part 1
    if length(phrase) == length(unique(phrase))
        % part 2
        lengths = strlength(phrase);
        [slen,id] = sort(lengths);
        phrase = phrase(id);
        sums = sum(char(phrase)-' ',2);
        
        [uslen,~,idx] = unique(slen)
        % res = all(arrayfun(@(value) length((sums(slen == value))) == length(unique(sums(slen == value))), uslen));
        [usums,a,b] = unique(sums);
        multis = histcounts(b,1:max(b)+1);
        % multiOcs = 
        res1 = length(usums) == length(sums);
        % if res ~= res1
        %     asda = 1;
        % end
        if res1
            valid = valid + 1;
        else
            candidates = arrayfun(@(value) find(sums == value), usums(multis>1), 'UniformOutput', false);
            fl = 0;
            for j=1:length(candidates)
                can = candidates{j};
                if size(unique(sort(char(phrase(can)),2),'rows'),1) < size(char(phrase(can)),1)
                    break
                end
                fl = fl + 1;
            end
            if fl == length(candidates)
                valid = valid + 1;
            end
        end
    end
end
valid