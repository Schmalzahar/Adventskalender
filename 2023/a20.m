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
for k=1:1000000000000
    while ~isempty(new_in)
        in = string(new_in(1));        
        new_in(1) = [];
        pulse = newpulse(1);
        if strcmp(in,'rx') && pulse == 0
            test = 1;
        end
        newpulse(1) = [];
        in_spl = strtrim(in.split(','));
        for i=1:height(in_spl)
            in = in_spl(i);
            % if pulse == 1
            %     pulses(2) = pulses(2) + 1;
            % else
            %     pulses(1) = pulses(1) + 1;
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