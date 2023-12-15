input = readlines('a15.txt').split(',');
values = 0;
boxes = dictionary;
for i=1:height(input)
    value = 0;
    str = char(input(i));
    lens_label = extract(str,lettersPattern);
    lens_label = lens_label{1};
    for j=1:length(lens_label)
        ascii = str(j)-0;
        value = value + ascii;
        value = value * 17;
        value = mod(value, 256);
    end
    lens_label = string(lens_label);
    box_number = value;
    
    if contains(str,'-')
        % go to box_number and remove lens_label
        if isKey(boxes, box_number)
            contents = boxes{box_number};
            if ~isempty(contents) && any([contents{:,1}] == string(lens_label))
                contents([contents{:,1}] == string(lens_label),:) = [];
                boxes{box_number} = contents;
            end
        end
        
    else
        % place focal length lens_label in box
        if ~isConfigured(boxes) || ~isKey(boxes, box_number)
            boxes{box_number} = {lens_label, extractAfter(str,'=')};
        elseif isKey(boxes, box_number)
            contents = boxes{box_number};
            if ~isempty(contents) && any([contents{:,1}] == string(lens_label))
                contents{[contents{:,1}] == string(lens_label),2} = extractAfter(str,'=');
                boxes{box_number} = contents;
            else
                boxes{box_number} = [contents; {lens_label, extractAfter(str,'=')}];
            end
        end
    end
end
%% focusing power
power = 0;
box_keys = boxes.keys;
box_vals = boxes.values;
for i=1:height(box_vals)
    val = box_vals{i};
    for j=1:height(val)
        power = power +  (box_keys(i)+1) * j * str2double(val{j,2});
    end
end
power