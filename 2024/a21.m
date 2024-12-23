input = readlines("a21.txt");

tic
keypad = ['789';
          '456';
          '123';
          ' 0A'];

robotPad = [' ^A';
            '<v>'];

maxLevel = 4-2+25;

numMoves = movesX(keypad);
padMoves = movesX(robotPad);

compl = 0;
for in = input'
    seq = ['A' char(in)]; % we always start at A
    shortestSeq = 0;
    for k=1:numel(seq)-1
        out = minNumPresses(seq(k), seq(k+1), numMoves, padMoves, 1, maxLevel);
        shortestSeq = out + shortestSeq;
    end
    compl = compl + shortestSeq * str2double(seq(2:end-1));
end
int64(compl)
toc

function minLength = minNumPresses(start, fin, X1, X2, level, maxLevel)    

    if level == 1
        padStruct = X1;
    else
        padStruct = X2;
    end

    if level == maxLevel
        minLength = 1;
        return
    end   

    persistent lenCache
    if isempty(lenCache)
        lenCache = NaN(12, 12, maxLevel-1);
    end

    ops = padStruct.ops; pad = padStruct.pad;

    %
    startPos = start == pad;
    finPos = fin == pad;

    cacheVal = lenCache(startPos, finPos, level);
    if ~isnan(cacheVal)
        minLength = cacheVal;
        return
    end

    seqs = ops{startPos, finPos};
    lengths = zeros(size(seqs,1),1);
    for o=1:size(seqs,1)
        seq = seqs{o,1};
        for s=1:numel(seq)-1
            lengths(o) = lengths(o) + minNumPresses(seq(s), seq(s+1), X1, X2, level + 1, maxLevel);
        end      
    end
    minLength = min(lengths);
    lenCache(startPos, finPos, level) = minLength;
end



function X = movesX(pad)
    % returns the possible moves from each point for both keypad variants.
    numFields = numel(pad);
    [r,c] = ind2sub(size(pad), (1:numFields)');
    moves = cell(numFields, numFields);
    dr = r' - r;
    dc = c' - c;
    sgn = ['^ v';'< >'];

    for i=1:numFields
        for j=1:numFields
            if i == j
                moves{i,j} = {'AA'};
                continue
            end
            % possible moves to move from index i to j
            % moves to do:
            moveDown = dr(i,j);
            sD = sign(moveDown);          
            moveRight = dc(i,j); 
            sR = sign(moveRight);
            upDown = repelem(sgn(1,sD+2), abs(moveDown));
            leftRight = repelem(sgn(2,sR+2), abs(moveRight));            

            % now remove options that move over empty field.
            % path of upDown and leftRight
            pUD = @(x) [(r(i)+sD:sD:r(j))' repelem(c(x),abs(moveDown),1)];
            pLR = @(x) [repelem(r(x),abs(moveRight),1) (c(i)+sR:sR:c(j))'];
            % paths option A and B
            pA = [pUD(i); pLR(j)]; 
            pB = [pLR(i); pUD(j)];
            padPathA = pad(sub2ind(size(pad),pA(:,1),pA(:,2)));
            padPathB = pad(sub2ind(size(pad),pB(:,1),pB(:,2)));           

            % option A: move up/down first; option B: move left/right first
            % first A accounts for robot always starting at A
            % last A: robot has to press A
            temp = cell(0,1);
            if ~any(padPathA == ' ')
                temp{end+1,1} = ['A' upDown leftRight 'A'];
            end
            if ~any(padPathB == ' ') && ~(moveDown == 0 || moveRight == 0)
                temp{end+1,1} = ['A' leftRight upDown 'A']; 
            end
            moves{i,j} = temp;
        end
    end

    X = struct;
	X.ops = moves;
	X.pad = pad;    
end