%% without graph
data = char(readlines("input_a23.txt"));
additional = ['  #D#C#B#A#  ';'  #D#B#A#C#  '];
hallway = 1:11;
part = 2;
if part == 1
    room = data(3:4,4:2:10)-'@';
else
    room = [data(3,4:2:10);additional(:,4:2:10);data(4,4:2:10)] - '@';
end

function neighbor_nodes = findNodes(hallway, room)
    allowed_hallway = [1 2:2:10 11];
    room_id = [3:2:9];

    % 2 options: room to hallway or hallway to correct room
    % option 1:
end