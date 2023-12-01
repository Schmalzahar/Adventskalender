close all
code = readmatrix("input_13.txt");
% [out, code] = run_intcode(code, 0, 0, 1, 0, true);
% screen = drawScreen(out);
% image(screen)
% res1 = sum(screen(:,:,1) == 1,"all");
%% part 2
code(1) = 2;
% [out, code] = run_intcode(code, 0, 0, 1, 0, true);
% screen = drawScreen(out);
% image(screen)
% for i=1:20
%     [score, code] = arcade(code, 0);
% end
% for i=1:20
%     [score, code] = arcade(code, -1);
% end
% for i=1:20
%     [score, code] = arcade(code, 1);
% end
i = 1;
rel_base = 0;
next_inp = 0;
disp_data = [];
use_input = false;
x = 0;
first = true;
prev_screen = [];
while true
    [out, code] = run_intcode(code, next_inp, next_inp, i, rel_base, true, true, use_input);
    if iscell(out)
        i = out{2};
        rel_base = out{3};
        disp_data = [disp_data out{1}];
    end
    [screen, score] = drawScreen(disp_data);
    image(screen)
    if first
        set(gcf,'CurrentCharacter','@');
        first = false;
        prev_screen = screen;
    elseif screen == prev_screen
        break
        % loose
    end
    prev_screen = screen;
    drawnow
    k=get(gcf,'CurrentCharacter');
    if k~='@'
        set(gcf,'CurrentCharacter','@');
        if k == 'l'
            next_inp = -1;
        elseif k == 'n'
            next_inp = 0;
        elseif k == 'r'
            next_inp = 1;
        end
    end
%     x = input('Next move (0,1 or -1): ');
%     if ismember(x, [0 1 -1])
%         next_inp = x;
%     elseif strcmp(x,'exit')
%         break
%     end
    use_input = true;
    pause(1)
end

function [score, code] = arcade(code,dir)
    [out, code] = run_intcode(code, dir, 0, 1, 0, true);
    [screen, score] = drawScreen(out);
    image(screen)
    drawnow
end

function [screen,score] = drawScreen(out)
    % empty: white
    % wall: black
    % block: red
    % paddle: blue
    % ball: green
    screen = nan(25,35,3);
    score = 0;
    for i=1:numel(out)/3
        instruction = out((i-1)*3+1:i*3);
        if instruction(1) == -1 && instruction(2) == 0
            score = instruction(3);
        elseif ismember(instruction(3),[0 1 2 3 4])
            switch instruction(3)
                case 0
                    c1 = 1; c2 = 1; c3 = 1;
                case 1
                    c1 = 0; c2 = 0; c3 = 0;
                case 2
                    c1 = 1; c2 = 0; c3 = 0;
                case 3
                    c1 = 0; c2 = 0; c3 = 1;
                case 4
                    c1 = 0; c2 = 1; c3 = 0;
            end
            screen(instruction(2)+1,instruction(1)+1,1) = c1;
            screen(instruction(2)+1,instruction(1)+1,2) = c2;
            screen(instruction(2)+1,instruction(1)+1,3) = c3;
        end
    end
end