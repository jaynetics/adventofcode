# crystal build --release 2022/day24_all.cr && time ./day24_all

f = __FILE__.sub(/(day..)\K.*/, "_input")

alias Pos = Tuple(Int32, Int32)

GRID = {} of Pos => Char

File.read_lines(f, chomp: true).reverse_each.with_index do |line, y|
  line.chars.each_with_index { |chr, x| GRID[{x, y}] = chr }
end

MAX_X = GRID.keys.max_by(&.[0])[0]
MAX_Y = GRID.keys.max_by(&.[1])[1]

START = {1, MAX_Y}
DEST  = {MAX_X - 1, 0}

OPPONENTS = GRID.each_with_object([] of Tuple(Pos, Pos)) do |(pos, chr), acc|
  case chr
  when '>' then acc << {pos, {1, 0}}
  when 'v' then acc << {pos, {0, -1}}
  when '<' then acc << {pos, {-1, 0}}
  when '^' then acc << {pos, {0, 1}}
  end
end

# pre-calculate all possible position permutations of opponents
OPPONENT_STATES = (0..((MAX_X - 2).lcm(MAX_Y - 2))).map do |n|
  OPPONENTS.to_h do |(pos, vec)|
    x_at_time = ((pos[0] + vec[0] * n - 1) % (MAX_X - 1)) + 1 # +/-1 bc of walls
    y_at_time = ((pos[1] + vec[1] * n - 1) % (MAX_Y - 1)) + 1 # +/-1 bc of walls
    { {x_at_time, y_at_time}, true }
  end
end

POSSIBLE_MOVES = { {0, 1}, {1, 0}, {-1, 0}, {0, -1}, {0, 0} }
SEEN_ROUTES    = {} of Tuple(Pos, Pos, Int32) => Bool

def run(start, dest, previous_moves = 0)
  queue = [{start, previous_moves}]
  while queue.any?
    pos, moves = queue.shift
    route_id = {pos, dest, moves}
    next if SEEN_ROUTES[route_id]?

    SEEN_ROUTES[route_id] = true
    moves += 1
    opponents = OPPONENT_STATES[moves % OPPONENT_STATES.size]

    POSSIBLE_MOVES.each do |move|
      new_x = pos[0] + move[0]
      new_y = pos[1] + move[1]
      new_pos = {new_x, new_y}
      next if new_y < 0 || new_y > MAX_Y # outside grid, above START/below DEST
      next if opponents[new_pos]?        # blocked by opponent
      next if GRID[new_pos] == '#'       # blocked by wall
      return moves - previous_moves if new_pos == dest

      queue << {new_pos, moves}
    end
  end
  raise "no route found"
end

# part 1
to_dest = run(START, DEST)
puts to_dest

# part 2
back = run(DEST, START, to_dest)
to_dest_again = run(START, DEST, to_dest + back)
puts to_dest + back + to_dest_again
