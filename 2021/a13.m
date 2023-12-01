%% Day 13
input = readmatrix("input_a13.txt","OutputType","string");
marked = rmmissing(double(input));
% Mark on transparent paper
%xymax = max(marked,[],1);
xymax = [1310,894];
paper = false(xymax(end:-1:1)+1);
for i=1:size(marked,1)
    paper(marked(i,2)+1,marked(i,1)+1) = true;
end
% Folding
folds = input(size(marked,1)+1:end,1);
for fold = folds'
    position = str2double(extract(fold,digitsPattern));
    if contains(fold,'x')
        paper = paper'; % flip the paper for fold in other direction
    end
    part1 = paper(1:position,:);
    part2flip = paper(end:-1:position+2,:);
    % add the parts
    paper = part1 | part2flip;
    if contains(fold,'x')
        paper = paper'; % flip back
    end
end
% Read text
% scale up image
paper_large = imresize(paper,10);
ocrResults = ocr(paper_large,'TextLayout','Word');
disp("Result: "+ ocrResults.Words)