clear all
clc

S = str2double(readlines("a20.txt"))';
N = numel(S);
%% part 1
I_t = 1:numel(S); %index track

[I_t] = mix_decrypt(S,I_t)
S_decrypt = S(I_t);

I = find(S_decrypt == 0);
for i = 1:3
    temp = circshift(S_decrypt,-mod(i*1000,N));
    coords(i) = temp(I);
end

part_1 = sum(coords)
%% part 2
key = 811589153;
S2 = S*key;
I_t = 1:N; %index track
for mixes = 1:10 %repetitions
   [I_t] = mix_decrypt(S2,I_t);
end
S2_decrypt = S2(I_t);

I = find(S2_decrypt == 0);
for i = 1:3
    temp = circshift(S2_decrypt,-mod(i*1000,N));
    coords(i) = temp(I);
end

part_2 = sum(coords)


%% function
function [I_t] = mix_decrypt(S,I_t)
    N = numel(S);
    for i = 1:N
       I = find(I_t == i);
%        mv = mod(abs(S(i)),N-1);
%        mv = mod(S(i),N-1);
%        if S(i) < 0
%            mv = N - mv - 1;
%        end
% %        I2 = mod(I + mv,N);
%         I2 = mod(I + mv,N-1);
        I2 = mod(I+S(i),N-1);
        if I2 < 1
            I2 = N+I2-1;
        end
       if S(i) ~= 0
           if I2 == 0 
               I_t = [I_t([1:N] ~= I) I_t(I)];
           elseif I2 == 1 
               I_t = [ I_t(I) I_t([1:N] ~= I)];
           else
               I_t = [I_t([1:N]<=I2 & [1:N]~=I) I_t(I)  I_t([1:N]>I2 & [1:N]~=I)];
           end
       end
    end
end


