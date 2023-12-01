%% Day 16
input = char(readmatrix("input_a16.txt","OutputType","string"));
% Transform the hex string into binary, each hex is 4 bits long
input_bin = reshape(dec2bin(hex2dec(input(:))).',1,4*length(input));
global version_sum

tic
[output, value]  = readPacket_int(input_bin);
toc
disp("Version sum: "+version_sum)
disp("Value: "+value)

function [output, value] = readPacket(input, noOfPackets, type)
    % Read a new packet. The value of this new packet is empty
    % Read as long as input is not empty
    packet_value = double.empty;
    if noOfPackets < 1
        while ~isempty(input) && ~all(input=='0')
            [input, packet_value] = multiPack(input, packet_value);
        end        
    else
        for n = 1:noOfPackets    
            [input, packet_value] = multiPack(input, packet_value);
        end
    end
    op = {@sum, @prod, @min, @max, NaN, @(x) x(1) > x(2), @(x) x(1) < x(2), @(x) x(1) == x(2)};
    value = op{type+1}(packet_value);
    output = input;
end

function [output, packet_value] = multiPack(input, packet_value)
    [temp, value_out] = readPacket_int(input);
    output = temp;
    packet_value(end+1) = value_out;
end

function [data, value_out] = readPacket_int(data)
    % Version
    global version_sum;
    if isempty(version_sum)
        version_sum = 0;
    end
    version_sum = version_sum + bin2dec(data(1:3));
    T = bin2dec(data(4:6));
    data = data(7:end);
    switch T
        case {0,1,2,3,5,6,7}
            if data(1) == '0'
                len = bin2dec(data(2:16));
                [~, value_out] = readPacket(data(17:17+len-1), -1,T);
                data = data(17+len:end);
            else
                noOfSubpackets = bin2dec(data(2:12));
                [data, value_out] = readPacket(data(13:end), noOfSubpackets, T);
            end
        case 4
            re = "";
            while true
                 re = re + string(data(2:5)); 
                 temp = data(1) == '0';
                 data = data(6:end);
                 if temp                     
                     break
                 end                 
            end
            value_out = bin2dec(re);
    end    
end