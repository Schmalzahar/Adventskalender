input = char(readlines('a05.txt'));
tic
lengths = NaN(26,1);
for i=1:26
    new_input = input(input ~= char('`'+i));
    new_input = new_input(new_input ~= char('`' + i - 32));
    lengths(i) = rec(new_input);
end
min(lengths)
toc
function out = rec(line)
    out = 0;
    Ul = find(line(1:end-1)+32 == line(2:end)-0,1); % upper followed by lower
    lU = find(line(1:end-1)-0 == line(2:end)+32,1); % lower followed by upper
    i = min(Ul,lU);
    
    if isempty(i)
        if isempty(lU)
            i = Ul;
        end
        if isempty(Ul)
            i = lU;
        end
        if isempty(i)
            out = length(line);
            return
        end
    end

    line(i:i+1) = '';
    out = out + rec(line);
end