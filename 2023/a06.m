input = readlines("a06.txt").extract(digitsPattern).double;
% input = strrep(string(num2str(input))," ","").double; % for part 2
% with math: solve the quadratic equation x^2-xt+d<0, with t being the end
% time and d the minimum distance. The result is floor(x1)-floor(x2).
prod(floor(input(1,:)/2 + sqrt(input(1,:).^2-4*input(2,:))/2) - floor(input(1,:)/2 - sqrt(input(1,:).^2-4*input(2,:))/2))