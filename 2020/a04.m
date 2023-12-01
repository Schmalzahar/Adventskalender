input = fileread("input_04.txt");
pass_batch = string(strtrim(strsplit(input,newline)));
i=1;
count = 0;
while true
    j = 1;
    line_i = "";
    while true        
        if pass_batch(i) ~= ""
            line_i(j) = pass_batch(i);
        else
            i = i+1;
            break
        end
        i = i+1;
        if i > width(pass_batch)
            break
        end
        j = j+1;
    end
    passport = join(line_i,' ');
    check = ["byr" "iyr" "eyr" "hgt" "hcl" "ecl" "pid"];
    bool = true;
    for type = check        
        switch type
            case {"byr" "iyr" "eyr" "hgt"}
                str = type+':(?<'+type+'>\d*)';
            case "hcl"
                str = type+':(?<'+type+'>#\w{6})';
            case "ecl"
                str = type+':(?<'+type+'>\w{3})';
            case "pid"
                str = type+':(?<'+type+'>\d*)';
        end
        info = regexp(passport,str,'names');
        if isempty(info)
            bool = false;
            break
        end
        switch type
            case "byr"
                min = 1920;
                max = 2002;
                if ~(str2double(info.(type)) >= min && str2double(info.(type)) <= max)
                    bool = false;
                    break
                end                    
            case "iyr"
                min = 2010;
                max = 2020;
                if ~(str2double(info.(type)) >= min && str2double(info.(type)) <= max)
                    bool = false;
                    break
                end  
            case "eyr"
                min = 2020;
                max = 2030;
                if ~(str2double(info.(type)) >= min && str2double(info.(type)) <= max)
                    bool = false;
                    break
                end  
            case "hgt"
                cm_or_in = char(extractAfter(passport,type+':'+info.(type)));
                cm_or_in = cm_or_in(1:2);
                if strcmp(cm_or_in,'cm')
                    min = 150;
                    max = 193;
                elseif strcmp(cm_or_in,'in')
                    min = 59;
                    max = 76;
                else
                    bool = false;
                    break
                end
                if ~(str2double(info.(type)) >= min && str2double(info.(type)) <= max)
                    bool = false;
                    break
                end
            case "ecl"
                if ~ismember(info.(type), ["amb" "blu" "brn" "gry" "grn" "hzl" "oth"])
                    bool = false;
                    break
                end
            case "pid"
                if length(char(info.(type))) ~= 9
                    bool = false;
                    break
                end
        end
%         res = regexp(passport,'byr:(\d*)','tokens')
%         bool = bool & contains(passport,type);
    end
    if bool
        count = count + 1;
    end
    if i > width(pass_batch)
        break
    end
end
count