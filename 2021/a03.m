%% Day 3.1
data = char(readmatrix("input_a03.txt","OutputType","string"))-'0';
gamma = "";
for i=1:width(data)
    line_ox = data(:,i);
    if 2*sum(data(:,i)) > height(data)
        gamma = gamma + "1";
    else
        gamma = gamma + "0";
    end
end
gammadec = bin2dec(gamma);
epsdec = 2^width(data) - gammadec - 1;
result = gammadec * epsdec;
disp("Result: "+result);
%% 3.2
% Oxygen
ox = "";
data_ox = data;
data_c02 = data;
for i=1:width(data)
    if height(data_ox) > 1
        if 2*sum(data_ox(:,i)) >= height(data_ox)
            data_ox = data_ox(~~data_ox(:,i),:);
        else
            data_ox = data_ox(~data_ox(:,i),:);
        end
    end
    
    if height(data_c02) >1
        if 2*sum(data_c02(:,i)) >= height(data_c02)
            data_c02 = data_c02(~data_c02(:,i),:);
        else
            data_c02 = data_c02(~~data_c02(:,i),:);
        end
    end
end
oxdec = bin2dec(join(string((data_ox)),''));
c02dec = bin2dec(join(string((data_c02)),''));
result2 = oxdec * c02dec;
disp("Result 2: "+result2);