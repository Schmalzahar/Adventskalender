% Advent of Code Day 23
input = "./input_a23.txt";
data = char(readlines(input));

% Part 1
map = data;
hall = zeros(1,11);
room = map(3:4,4:2:10) - '@';

% ans_1 = find_min_path(hall, room)

% Part 2
map = data;
map = [map(1:3,:); ['  #D#C#B#A#  ';'  #D#B#A#C#  ']; map(4:end,:)];
hall = zeros(1,11);
room = map(3:6,4:2:10) - '@';

ans_2 = find_min_path(hall, room)

function cost = find_min_path(hall, room)
  hall_list = hall;
  room_list = room;
  cost_list = 0;
  hash_list = [];
  
  cnt = 0;
  cnt2 = 0;
  while true
    cnt = cnt + 1;
    cnt2 = cnt2 + 1;
    [s, i] = min(cost_list);
    hall = hall_list(:,:,i);
    room = room_list(:,:,i);
    
    if is_done(room)
      cost = s;
      return
    end
    
    h = state_to_hash(hall, room);
    if any(hash_list == h)
      cost_list(i) = Inf;
      continue
    else
      hash_list(end+1) = h;
    end
    
    [new_hall, new_room, new_cost] = valid_moves(hall, room);
    
    n = numel(new_cost);
    hall_list(:,:,end+1:end+n) = new_hall;
    room_list(:,:,end+1:end+n) = new_room;
    cost_list(end+1:end+n) = s + new_cost;
    
    cost_list(i) = Inf;
    
    if cnt2 > 10000
      cnt2 = 0;
      ind = cost_list < Inf;
      hall_list = hall_list(:,:,ind);
      room_list = room_list(:,:,ind);
      cost_list = cost_list(ind);
    end
  end
end

function [new_hall, new_room, new_cost] = valid_moves(hall, room)
  new_hall = zeros(0,0,0);
  new_room = zeros(0,0,0);
  new_cost = zeros(0);
  cost_ind = [1 10 100 1000];
  valid_hall = [1 2 4 6 8 10 11];
  room_loc = [3 5 7 9];
  n_room = size(room,1);
  room_open = sum(room == 1:4 | room == 0) == n_room;
  
  % move from hall to room
  for i = valid_hall
    if hall(i) == 0
      continue
    end
    c = hall(i);
    if room_open(c)
      k = room_loc(c);
      if i < k
        ind = i+1:k;
      else
        ind = k:i-1;
      end
      if any(hall(ind) > 0)
        continue
      end
      nh = hall;
      nr = room;
      nh(i) = 0;
      
      for j = 0:n_room-1
        jj = n_room-j;
        if nr(jj,c) == 0
          nr(jj,c) = c;
          vd = jj;
          break
        end
      end
      
      new_hall(:,:,end+1) = nh;
      new_room(:,:,end+1) = nr;
      new_cost(end+1) = cost_ind(c) * (vd + abs(room_loc(c) - i));
    end
  end
  
  % move from room to hall
  for i = 1:4
    if room_open(i)
      continue
    end
    k = room_loc(i);
    for j = valid_hall
      if j < k
        ind = j:k;
      else
        ind = k:j;
      end
      
      if ~any(hall(ind))
        nh = hall;
        nr = room;
        
        for m = 1:n_room
          if nr(m,i) ~= 0
            c = nr(m,i);
            nr(m,i) = 0;
            vd = m;
            break
          end
        end
        
        nh(j) = c;
        new_hall(:,:,end+1) = nh;
        new_room(:,:,end+1) = nr;
        new_cost(end+1) = cost_ind(c) * (vd + abs(k - j));
      end
    end
  end
end

function done = is_done(room)
  done = all(room == 1:4, 'all');
end

function h = state_to_hash(hall, room)
  h_ind = [1 2 4 6 8 10 11];
  m = [hall(h_ind), room(:)'];
  p = 5.^(numel(m)-1:-1:0);
  h = sum(p.*m);
end

function map = state_to_map(hall, room)
  map = zeros(5,13) + ' ';
  hall(hall > 0) = hall(hall > 0) + '@';
  hall(hall == 0) = '.';
  room(room > 0) = room(room > 0) + '@';
  room(room == 0) = '.';
  map(2,2:12) = hall;
  map(3:2+size(room,1),4:2:10) = room;
  map = char(map);
end
