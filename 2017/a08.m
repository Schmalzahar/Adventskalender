in = readlines("a08.txt");
regs = struct;
max_value = 0;
for i=1:height(in)
    line = in(i);
    cond = strsplit(line," if ");
    cond1 = extract(cond(2),lettersPattern);
    if ~isfield(regs,cond1)
        regs.(cond1) = 0;
    end
    cond(2) = replace(cond(2),lettersPattern, num2str(regs.(cond1)));
    cond(2) = replace(cond(2),"!","~");
    if eval(cond(2))
        temp = extract(cond(1),lettersPattern);
        modify_field = temp(1);
        if ~isfield(regs,modify_field)
            regs.(modify_field) = 0;
        end
        if strcmp(temp(2),"inc")
            temp1 = split(cond(1),"inc ");
            regs.(modify_field) = regs.(modify_field) + str2double(temp1(2));
        else
            temp1 = split(cond(1),"dec ");
            regs.(modify_field) = regs.(modify_field) - str2double(temp1(2));
        end
    end
    if max(cell2mat(struct2cell(regs))) > max_value
        max_value = max(cell2mat(struct2cell(regs)));
    end
end
max(cell2mat(struct2cell(regs)))