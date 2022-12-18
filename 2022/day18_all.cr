# crystal build --release 2022/day18_all.cr && time ./day18_all

f = __FILE__.sub(/(day..)\K.*/, "_input")

alias Pos = Tuple(Int8, Int8, Int8)
alias SurfaceCount = Int8
alias Grid = Hash(Pos, SurfaceCount)

GRID = Grid.new

File.each_line(f) do |line|
  x, y, z = line.scan(/\d+/).map { |md| md[0].to_i8 }
  GRID[{x, y, z}] = 1
end

def count_surfaces(grid : Grid)
  grid.keys.each do |pos|
    grid[pos] = 6_i8 - neighbors(pos).count { |nb_pos| grid[nb_pos]? }
  end
  grid.values.reduce(0_i64) { |a, e| a + e }
end

def neighbors(pos : Pos) : Array(Pos)
  x, y, z = pos
  [{x + 1, y, z}, {x - 1, y, z}, {x, y + 1, z}, {x, y - 1, z}, {x, y, z + 1}, {x, y, z - 1}]
end

# part 1
surface_count = count_surfaces(GRID)
puts surface_count

# part 2
all_x, all_y, all_z = [] of Int8, [] of Int8, [] of Int8
GRID.keys.each { |(x, y, z)| all_x << x; all_y << y; all_z << z }
min_x, max_x = all_x.minmax
min_y, max_y = all_y.minmax
min_z, max_z = all_z.minmax

on_edge = ->(pos : Pos) : Bool {
  x, y, z = pos
  x == min_x || y == min_y || z == min_z || x == max_x || y == max_y || z == max_z
}

GAP_GRID = Grid.new

def trace_gap(pos : Pos, on_edge : Proc, seen = Hash(Pos, Bool).new) : Bool | Array(Pos)
  return true if GRID[pos]? || GAP_GRID[pos]? || seen[pos]?
  return false if on_edge.call(pos)

  seen[pos] = true
  acc = [pos]
  neighbors(pos).each do |nb_pos|
    return false unless res = trace_gap(nb_pos, on_edge, seen)
    acc += res if res.is_a?(Array)
  end
  acc
end

((min_x + 1)...max_x).each do |x|
  ((min_y + 1)...max_y).each do |y|
    ((min_z + 1)...max_z).each do |z|
      res = trace_gap({x, y, z}, on_edge)
      res.is_a?(Array) && res.each { |gap_pos| GAP_GRID[gap_pos] = 1 }
    end
  end
end

puts surface_count - count_surfaces(GAP_GRID)
