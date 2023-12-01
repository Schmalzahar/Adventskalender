input = readlines("a01.txt");
count(input)
wordList = {'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'};
numberList = {"o1e", "t2o", "t3e", "4", "5e", "6", "7n", "e8t", "9e"};
for i=1:9                                       
    input = regexprep(input,wordList{i}, numberList{i});
end
count(input)
function out = count(input)
    first = regexp(input,'\d','match','once');
    last = regexp(input,'\d(?=\D*$)','match','once');
    out = sum(str2double(first+last));
end