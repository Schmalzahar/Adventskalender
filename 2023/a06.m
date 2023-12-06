input = readlines("a06.txt").extract(digitsPattern).double;
part2 = strrep(string(num2str(input))," ","").double;
input = part2;
winning = zeros(1,size(input,2));
for i=1:size(input,2)
    for j=0:input(1,i)
        speed = j;
        remaining_time = input(1,i)-j;
        dist = speed * remaining_time;
        if dist>input(2,i)
            winning(i) = winning(i) + 1;
        end
    end
end
prod(winning)