tic
input = readlines('a12.txt').replace('#','/');
rs = input.extractBefore(' ');
res = 0;
% res_p1 = zeros(height(input),1);
res_p2 = zeros(height(input),1);
% parpool(7)
parfor i=15:height(input)
    r = char(rs(i))-'.';
    rtest = repmat([r 17],1,2);
    rtest = rtest(1:end-1);
    % rtest = [r 17];
    r = rtest;
    r = r(find(r,1,'first'):find(r,1,'last'));
    nums = input(i).extract(digitsPattern).double;
    numstest = repmat(nums,2,1);
    nums = numstest;
    group_num = length(nums);

    unknown = find(r == 17);
    number_of_possible_combs = 2^length(unknown);  
    % try to get the number down
    while true
        r = r(find(r,1,'first'):find(r,1,'last')); % remove leading and trailing 0
        % when the ending of r cannot be a number
        if r(end) == 17 && r(end-1) == 0 && nums(end) > 1
            r = r(1:end-2);
        elseif r(end) == 17 && r(end-1) == 1 && nums(end) == 1
            r = r(1:end-2);
        end

        if find(r == 0,1) < nums(1)
            r = r(find(r == 0,1)+1:end);
        end

        if all(r(end-nums(end)+1:end) == 1)
            r = r(1:end-nums(end));
            nums = nums(1:end-1);
            group_num = group_num - 1;
        end

        if nums(end) > 1 && any(r(end-nums(end)+1:end) == 1) && r(end-nums(end)) == 0
            r(end-nums(end)+1:end) = 1;
        end

        if r(1) == 1 && r(2) == 17
            if nums(1) == 1
                r(2) = 0;
            elseif nums(1) > 1
                r(2) = 1;
            end
        end
        if all(r(1:nums(1)) == 1)
            r = r(nums(1)+1:end);
            nums = nums(2:end);
            group_num = group_num - 1;
        end

        if all(r(1:3) == 1) && r(4) == 17 && nums(1) == 3
            r(4) = 0;
        end

        if max(nums) > 2
            % whats the distance of connected 1's and 17's?
            ones = find(r == 1);
            if nums(1) > ones(1)
                % first one is included in first num group
                for n=1:nums(1) 
                    if any(r(ones(1)+n) == [1 17]) && ones(1)+n<=nums(1)
                        r(ones(1)+n) = 1;
                    else
                        break
                    end
                end

            end
            if max(nums) > 6
                max_idxs = find(nums == max(nums));
                for max_idx = max_idxs'
                    % worst_case
                    worst_case_idx = sum(nums(1:max_idx-1)) + (max_idx-1) + 1;
                    if all(ismember(r(worst_case_idx:worst_case_idx+max(nums)-1), [1 17]))
                        while r(worst_case_idx+max(nums)) == 1
                            worst_case_idx = worst_case_idx + 1;
                        end
                        if r(worst_case_idx+max(nums)) ~= 1
                            % other_direction
                            min_needed_space = sum(nums(max_idx+1:end))+ (numel(nums)-max_idx);
                            leftover = r(1:length(r) - min_needed_space + 1);
                            leftover(1:worst_case_idx-1) = 0;
                            ones = find(leftover == 1);
                            r(ones(1):ones(end)) = 1;
                        end
                    end
                end
                
            end
        end

        if nums(1) == 1 && r(2) == 1
            r = r(2:end);
        end



        unknown = find(r == 17);
        new_number_of_possible_combs = 2^length(unknown);   
        if new_number_of_possible_combs == number_of_possible_combs
            number_of_possible_combs = new_number_of_possible_combs;
            break
        end
        number_of_possible_combs = new_number_of_possible_combs;
    end
    if number_of_possible_combs > 2^25
        test = 1;
    end
    combis = dec2bin(0:number_of_possible_combs-1)-'0';
    all_possibilities = zeros(number_of_possible_combs, length(r));
    all_possibilities(:, unknown) = combis;
    all_possibilities(:, r ~= 17) = repmat(r(r~=17), number_of_possible_combs, 1);
    conn_comb = zeros(size(all_possibilities));
    for k=1:number_of_possible_combs
        d = diff([0 all_possibilities(k,:)]);
        % replace the nth occurance of 1/-1 with n/-n
        ones = find(d == 1); mones = find(d == -1);
        d(ones) = 1:length(ones);
        d(mones) = -(1:length(mones));
        conn_comb(k,:) = cumsum(d);
        % conn_comb(k,:) = bwlabel(all_possibilities(k,:)) % alternative, but slow
    end
    % there must be group_num groups, to only use those rows with
    % max(conn_comb) = group_num
    conn_comb = conn_comb(max(conn_comb,[],2) == group_num,:);
    if size(conn_comb,1) == 1
        res = res + 1;
    else
        % now check whether the groups have the right size        
        for j=1:group_num
            conn_comb = conn_comb(sum(conn_comb == j,2) == nums(j),:);
        end
        res = res + size(conn_comb,1);
        
    end
    res_p2(i,:) = size(conn_comb,1);
    % i
end
res

res_p1.^((2-5)/(2-1)).*res_p2.^(4/(2-1))
toc