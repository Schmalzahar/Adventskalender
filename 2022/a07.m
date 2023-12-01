%% Day 7
% part 1: 07:54-09:40
% part 2: 09:40-09:49
tic
a = readlines("a07.txt");
current_dir = '/';
new_edges = cell(height(a),3);
for i=3:height(a) % start after the first ls command
    line = char(a(i));
    if strcmp(line(1:4),'$ cd')           
        if strcmp(line(6:7),'..')
            temp = regexp(current_dir,'^(.*)/','tokens'); % extract everything before the last /
            current_dir = temp{1}{1};
        else
            current_dir = append(current_dir,'/',line(6:end));
        end
    elseif ~strcmp(line(1:4),'$ ls') 
        new_edges{i,1} = current_dir;
        if strcmp(line(1:3),'dir')
            new_edges{i,2} = append(current_dir,'/',line(5:end));
            new_edges{i,3} = 0;
        else
            line_split = strsplit(line,' ');            
            new_edges{i,2} = append(current_dir,'/',line_split{2});
            new_edges{i,3} = str2double(line_split{1});
        end
    end
end
%% Search all dirs that have a file size < max_sum and add up their sums
max_sum = 100000;
max_disk_space = 70000000;
unused_needed = 30000000;

edges = new_edges(~cellfun('isempty',new_edges(:,1)),:);
folders = unique(edges(:,1));
folder_size = NaN(height(folders),1);
for i=height(folders):-1:1
    folder_size(i) = sum(cell2mat(edges(ismember(edges(:,1),folders(i)),3)));
    edges(ismember(edges(:,2),folders(i)),3) = {folder_size(i)};
end

needed_free_space = unused_needed - (max_disk_space - folder_size(1));
sorted_folder = sort(folder_size);
options = sorted_folder(sorted_folder >= needed_free_space);
disp("The sum of every directory smaller than "+max_sum+" is "+sum(folder_size(folder_size <= max_sum)))
disp("The total size of the directory to delete is " +options(1))
toc