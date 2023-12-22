input = readlines('a20.txt').split(' -> ');
tic
in_keys = char(input(:,1));
in_keys = strtrim(string(in_keys(:,2:end)));
ff = contains(input(:,1),'%');
cn = contains(input(:,1),'&');
last_vals = zeros(height(input),1);
t = cell(height(input),1);
for i=1:height(t)
    t{i,1} = {input(i,2), last_vals(i)};
end
map = dictionary(in_keys, t);
flip_vals = dictionary(in_keys(ff), zeros(sum(ff),1));
conj_keys = in_keys(cn);
conj_vals = dictionary;
for i=1:sum(cn)
    ck = conj_keys(i);
    conj_vals(ck) = {in_keys(contains(input(:,2),ck))};
end
pulses = [0 0];
newpulse = 0;
new_in = "roadcaster";
for k=1:15000
    while ~isempty(new_in)
        in = string(new_in(1));        
        new_in(1) = [];
        pulse = newpulse(1);
        
        newpulse(1) = [];
        in_spl = strtrim(in.split(','));
        for i=1:height(in_spl)
            in = in_spl(i);
            % tests for part 2
            % if strcmp(in,'vm') && pulse == 0
            %     test = 1; % k=4051,8102,12153
            % end
            % if strcmp(in,'vb') && pulse == 0
            %     test = 1; % k=3793,7586,11379
            % end
            % if strcmp(in,'kv') && pulse == 0
            %     test = 1; % k=4013,8026,12039
            % end
            % if strcmp(in,'kl') && pulse == 0
            %     test = 1; % k=3917,7834,11751
            % end
 
            if isKey(flip_vals, in) && ~pulse
                if flip_vals(in) == 0
                    flip_vals(in) = 1;  
                    newpulse1 = 1;
                else
                    flip_vals(in) = 0;
                    newpulse1 = 0;
                end    
                map{in}{2} = newpulse1;
                newpulse = [newpulse newpulse1];
                new_in = [new_in map{in}{1}];
            elseif isKey(conj_vals, in)
                inputs = conj_vals{in};
                t = reshape([map{inputs}]',2,[])';
                if all([t{:,2}])
                    newpulse1 = 0;
                else
                    newpulse1 = 1;                    
                end
                map{in}{2} = newpulse1;
                newpulse = [newpulse newpulse1];
                new_in = [new_in map{in}{1}];
            elseif strcmp(in, 'roadcaster')
                newpulse = [newpulse pulse];
                new_in = [new_in map{in}{1}];
            end
        end
    end
    newpulse = 0;
    new_in = "roadcaster";
end
prod(pulses)
toc




%% Part 2 build a graph
gr = digraph();
gr = addedge(gr,"roadcaster",[strtrim(map{'roadcaster'}{1}.split(','))]);
t = in_keys(in_keys ~= 'broadmaster');
for i=1:height(t)
    gr = addedge(gr,t(i),strtrim(map{t(i)}{1}.split(',')));
end
gr = simplify(gr);
h = plot(gr,'Layout','layered');
highlight(h, conj_keys, 'NodeColor','red')
highlight(h, 'll','rx','EdgeColor','magenta') % magenta: needs to be low
highlight(h, ["vm", "vb", "kv", "kl"], "ll","EdgeColor","green") % green: needs to be high
highlight(h, "th", "vm","EdgeColor","magenta")
highlight(h, "tj", "vb","EdgeColor","magenta")
highlight(h, "hb", "kv","EdgeColor","magenta")
highlight(h, "ff", "kl","EdgeColor","magenta")
% requirement for low rx: all high inputs into ll
% requirement for high input into ll:
% - low inputs into: vb, kv, vm, kl
% - vb: every 3793 steps
% - kv: every 4013 steps
% - vm: every 4051 steps
% - kl: every 3917 steps

resp2 = lcm(lcm(lcm(4051,3793),4013),3917)