# crystal build --release 2022/day23_all.cr && time ./day23_all

F = __FILE__.sub(/(day..)\K.*/, "_input")

alias Pos = Tuple(Int32, Int32)

GRID = {} of Pos => Bool
DIRS = [{0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}]

def init_grid
  lines = File.read(F).lines
  lines.each_with_index do |line, row|
    y = lines.size - row - 1
    line.chomp.each_char.with_index { |chr, x| GRID[{x, y}] = chr == '#' }
  end
end

def move(options)
  seen_destinations = [] of Pos
  proposals = GRID.each_with_object({} of Pos => Pos) do |(pos, elf), acc|
    next unless elf && (dest = find_destination(pos, options))

    if seen_destinations.includes?(dest)
      acc.delete(dest)
    else
      acc[dest] = pos
      seen_destinations << dest
    end
  end

  proposals.count do |(dest, from)|
    GRID[from] = false
    GRID[dest] = true
  end
end

def find_destination(pos, options)
  return if DIRS.none? { |dir| check(pos, dir) }

  options.each do |dir|
    idx = DIRS.index(dir) || raise(dir.to_s)
    checks = [dir, DIRS[(idx + 1) % DIRS.size], DIRS[(idx - 1) % DIRS.size]]
    return {pos[0] + dir[0], pos[1] + dir[1]} if checks.none? { |c| check(pos, c) }
  end
end

def check(pos, dir)
  GRID[{pos[0] + dir[0], pos[1] + dir[1]}]?
end

def grid_to_s
  elven_coords = GRID.select { |_, elf| elf }.keys
  min_x, max_x = elven_coords.map(&.[](0)).minmax
  min_y, max_y = elven_coords.map(&.[](1)).minmax
  max_y.downto(min_y).map do |y|
    y.to_s.ljust(4) + (min_x..max_x).map { |x| GRID[{x, y}]? ? '#' : '.' }.join
  end.join('\n')
end

# part 1
init_grid
options = [DIRS[0], DIRS[4], DIRS[6], DIRS[2]] # N, S, W, E
10.times { |n| move(options.rotate(n)) }
puts grid_to_s.count('.')

# part 2
GRID.clear
init_grid
(0..).each { |n| break puts(n + 1) if move(options.rotate(n)).zero? }
