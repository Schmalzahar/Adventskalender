input = readlines("a21.txt");
% input = "37"

keypad = ['7' '8' '9';'4' '5' '6'; '1' '2' '3'; NaN '0' 'A']; % 10: A

robotPad = [NaN '^' 'A'; '<' 'v' '>'];
compl = 0;
for i=1:height(input)
    door_code = char(input(i));

    %% moves on the door code
    % current position: A
    [cpx, cpy] = find('A' == keypad);
    instrRob1 = '';
    for j=1:length(door_code)
        door_let = door_code(j);
        [x, y] = find(door_let == keypad);
    
        % moves to do:
        moveUp = cpx - x;
        moveLeft = cpy - y;

        newInstrRob1 = '';

        if moveLeft > 0
            newInstrRob1 = [newInstrRob1  repelem('<',moveLeft)];
        else
            newInstrRob1 = [newInstrRob1  repelem('>',-moveLeft)];
        end

        if moveUp > 0
            newInstrRob1 = [newInstrRob1  repelem('^',moveUp)];
        else
            newInstrRob1 = [newInstrRob1  repelem('v',-moveUp)];
        end

        if moveUp ~= 0 && moveLeft ~= 0
            % more than one optimal move possible.
            combs = unique(perms(newInstrRob1),'rows');
            % also make sure we dont walk over the empty field
            if cpx == 4
                % in this case we cannot have two <'s before moving up
                left_idx = combs == '<'; up_idx = combs == '^';
                [~,firstUp] = max(up_idx, [], 2);
                mask = (1:size(combs, 2)) < firstUp;
                leftBeforeUp = sum(combs == '<' & mask, 2) < 2;
                combs = combs(leftBeforeUp,:);     

                
            elseif x == 4 && cpy == 1
                % in this case we cannot move down to x when we are at y=1
                test = 1;
            end
            if ~isempty(instrRob1)
            % instrRob1 = [repmat(instrRob1,size(combs,1),1) combs repmat('A',size(combs,1),1)];
                instrRob1 = [repmat(instrRob1,size(combs,1),1) repmat(combs,size(instrRob1,1),1)];
                instrRob1 = [instrRob1 repmat('A',size(instrRob1,1),1)];
            else
                instrRob1 = [combs repelem('A',size(combs,1),1)];
            end
        else
            if ~isempty(instrRob1)
                instrRob1 = [instrRob1 repmat([newInstrRob1 'A'],size(instrRob1,1),1) ];
            else
                instrRob1 = [newInstrRob1 'A'];
            end
        end        
        cpx = x; cpy = y;
    end

    %% Now we have the first code.
    inputCode = string(instrRob1);    
    for j=1:25
        [cpx, cpy] = find('A' == robotPad);
        new_inst = [];
        for p=1:size(inputCode,1)            
            instrNextRob = '';
            ipC = char(inputCode(p));
            for k=1:length(ipC)
                rob_let = ipC(k);
                [x, y] = find(rob_let == robotPad);
    
                % moves to do:
                moveUp = cpx - x;
                moveLeft = cpy - y;
    
                if moveUp < 0
                    instrNextRob = [instrNextRob  repelem('v',-moveUp)];
                end
    
                if moveLeft < 0
                    instrNextRob = [instrNextRob  repelem('>',-moveLeft)];
                elseif moveLeft > 0
                    instrNextRob = [instrNextRob  repelem('<',moveLeft)];
                end
    
                if moveUp > 0
                    instrNextRob = [instrNextRob  repelem('^',moveUp)];
                end
    
                % Press A
                instrNextRob = [instrNextRob 'A'];
                cpx = x; cpy = y;
            end    
            % pass this on to the next robot
            % inputCode = instrNextRob;
            new_inst = [new_inst; string(instrNextRob)];
            [cpx, cpy] = find('A' == robotPad);
        end
        inputCode = new_inst;
    end

    compl = compl + min(strlength(inputCode)) * str2double(door_code(1:3));
end
compl