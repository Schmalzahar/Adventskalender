%% Day 24
inp = fileread("input_a24.txt");
inp = string(strtrim(strsplit(inp,newline)))';
var.("x") = 0;
var.("y") = 0;
var.("z") = 0;
var.("w") = 0;
for i=1:10
    var.("x") = 0;
    var.("y") = 0;
    var.("z") = 0;
    var.("w") = 0;
    once = true;
    j = 1;
    while true
        line = inp(j);
        %inp = inp(2:end);
        line_split = strsplit(line," ");
        instruction = line_split(1);
        if strcmp(instruction,"inp")
            if once
                once = false;
            else
                break
            end
        end
        j = j+1;
        var1 = line_split(2);
        if width(line_split) >2
            var2 = line_split(3);
        else
            %var2 = input('Enter a number: ');
            %var2 = str2double(num(1));
            %num = num(2:end);
            var2 = i;
        end
        switch instruction
            case "inp"
                var.(var1) = var2;
            case "add"
                var.(var1) = var.(var1) + v(var,var2);
            case "mul"
                var.(var1) = var.(var1) * v(var,var2);
            case "div"
                var.(var1) = floor(var.(var1) / v(var,var2));
            case "mod"
                var.(var1) = mod(var.(var1), v(var,var2));
            case "eql"
                var.(var1) = var.(var1) == v(var,var2);
        end
        var
    end
    var
end
%%
% Advent of Code Day 24
input = "input_a24.txt";
data = char(readlines(input));
prog = data(1:end-1,:);
A = str2double(string(prog((0:13)*18 + 5, 7:end)));
B = str2double(string(prog((0:13)*18 + 6, 7:end)));
C = str2double(string(prog((0:13)*18 + 16, 7:end)));

ans_1 = find_best(9:-1:1, A, B, C);
fprintf('ans_1: %s\n', sprintf('%d', ans_1));
ans_2 = find_best(1:9, A, B, C);
fprintf('ans_2: %s\n', sprintf('%d', ans_2));

function best_seq = find_best(vals, A, B, C)
  % x = rem(z,26) + B ~= INP
  % z = floor(z/A)*(25 * x + 1) + (INP + C) * x
  input = vals(:); % column vector
  best_seq = zeros(1,14);
  hist_z{1} = 0;
  for j = 1:14
    z0 = hist_z{j};
    for guess = input'
      z = z0;
      % Initialize with guess of jth number
      x = rem(z,26) + B(j) ~= guess;
      z = unique(floor(z/A(j)).*(25*x + 1) + (guess + C(j)).*x)';
      hist_z{j+1} = z;
      % Iterate through all end values, do any paths lead to z = 0?
      for i = j+1:14
        x = rem(z,26) + B(i) ~= input;
        z = unique(floor(z/A(i)).*(25*x + 1) + (input + C(i)).*x)';
      end
      if any(z == 0, 'all')
        best_seq(j) = guess;
        break
      end
    end
  end
end
%%
% for i=1:height(inp)
%     line = inp(i);
%     line_split = strsplit(line," ");
%     instruction = line_split(1);
%     var1 = line_split(2);
%     if width(line_split) >2
%         var2 = line_split(3);
%     else
%         %var2 = input('Enter a number: ');
%         var2 = str2double(num(1));
%         num = num(2:end);
%     end
%     switch instruction
%         case "inp"
%             var.(var1) = var2;
%         case "add"
%             var.(var1) = var.(var1) + v(var,var2);
%         case "mul"
%             var.(var1) = var.(var1) * v(var,var2);
%         case "div"
%             var.(var1) = floor(var.(var1) / v(var,var2));
%         case "mod"
%             var.(var1) = mod(var.(var1), v(var,var2));
%         case "eql"
%             var.(var1) = var.(var1) == v(var,var2);
%     end
% end

function out = v(var, var1)
    if ~isnan(str2double(var1))
        out = str2double(var1);
    else
        out = var.(var1);
    end
end

function var = setvars(in)
%     x = NaN;
%     y = NaN;
%     z = NaN;
%     w = NaN;
%     switch in
%         case "x"
%             x = 0;
%         case "y"
%             y = 0;
%         case "z"
%             z = 0;
%         case "w"
%             w = 0;
%     end
    var.("x") = 0;
    var.("y") = 0;
    var.("z") = 0;
    var.("w") = 0;
end