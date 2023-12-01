input = readlines("input_19.txt");
for i=1:height(input)
    if input(i) == ""
        break
    end
end
rules = input(1:i-1);
messages = input(i+1:end);
rule_num = str2double(extractBefore(rules,':'));
rules = extractAfter(rules,': ');
[rule_num,sid] = sort(rule_num);
rules = rules(sid);
crules = cellrules(rules);
tic
part1 = sum(arrayfun(@(i) test(char(messages(i)),0,crules),1:height(messages)))
rules(9) = "42 | 42 8";
rules(12) = "42 31 | 42 11 31";
crules = cellrules(rules);
part2 = sum(arrayfun(@(i) test(char(messages(i)),0,crules),1:height(messages)))
toc
function bool = test(m,id,rules)
    if m == "" || isempty(id)
        bool = m == "" && isempty(id);
        return
    end
    r = rules{id(1)+1};
    if ~iscell(r)
        if contains(r,m(1))
            bool = test(m(2:end),id(2:end),rules);
            return
        else
            bool = false;
            return
        end
    else
        bool = false(width(r),1);
        for i=1:width(r)
            if isempty(id(2:end))
                bool(i) = test(m,r{i},rules);
            else
                bool(i) = test(m,[r{i} id(2:end)],rules);
            end
        end
        bool = any(bool);
        return
    end
end

function c_rules = cellrules(rules)
    c_rules = cellstr(rules);
    for i=1:height(c_rules)
        if ~contains(c_rules{i},'"')
            sp = strsplit(c_rules{i},'|');
            tmp = {};
            for j=1:width(sp)
                tmp{1,end+1} = str2double(extract(sp{j},digitsPattern))';
            end
            c_rules{i} = tmp;
        end
    end
end