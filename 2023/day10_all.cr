# crystal build --release 2023/day10_all.cr && time ./day10_all

F = __FILE__.sub(/(day..)\K.*/, "_input")

n, e, s, w = 0_i8, 1_i8, 2_i8, 3_i8

types = {
  '|' => {n, s},
  '-' => {e, w},
  'L' => {n, e},
  'J' => {n, w},
  '7' => {s, w},
  'F' => {s, e},
  'S' => {-1_i8, -1_i8},
  '.' => {-2_i8, -2_i8},
}

struct Node
  property chr, x, y, end_a, end_b

  def initialize(@chr : Char, @x : Int16, @y : Int16, @end_a : Int8, @end_b : Int8)
  end

  def adjacents(grid : Grid)
    [(r = grid[y - 1]?) && r[x]?, (r = grid[y + 1]?) && r[x]?, grid[y][x - 1]?, grid[y][x + 1]?]
  end

  def ends
    [end_a, end_b]
  end
end

alias Row = Hash(Int16, Node)
alias Grid = Hash(Int16, Row)

grid = Grid.new

File.read_lines(F, chomp: true).reject(&.empty?).each_with_index do |line, y|
  grid[y.to_i16] = row = Row.new
  line.each_char.with_index { |c, x| row[x.to_i16] = Node.new(c, x.to_i16, y.to_i16, *types[c]) }
end

start = grid.values.flat_map(&.values).find(&.chr.==('S')).not_nil!

starts = [] of Tuple(Node, Int8)
start.adjacents(grid).each do |adj|
  starts << {adj, n} if adj && adj.y > start.y && adj.ends.includes?(n)
  starts << {adj, e} if adj && adj.x < start.x && adj.ends.includes?(e)
  starts << {adj, s} if adj && adj.y < start.y && adj.ends.includes?(s)
  starts << {adj, w} if adj && adj.x > start.x && adj.ends.includes?(w)
end
node_a, end_a = starts[0]
node_b, end_b = starts[1]
route_a, route_b = [node_a, node_b].map { |n| [n] }
dirs = {n => {0, -1, s}, s => {0, 1, n}, e => {1, 0, w}, w => {-1, 0, e}}

loop do
  dx_a, dy_a, end_a = dirs[(node_a.ends - [end_a]).first]
  dx_b, dy_b, end_b = dirs[(node_b.ends - [end_b]).first]
  node_a = grid[node_a.y + dy_a][node_a.x + dx_a]
  node_b = grid[node_b.y + dy_b][node_b.x + dx_b]
  route_a << node_a
  route_b << node_b
  break if route_a.includes?(route_b.last)
end

# part 1
p [route_a, route_b].map(&.size).min

# part 2 :D
main_loop = route_a + route_b + [start]

resolution = 3
width, height = [grid.values.first.size, grid.size].map(&.*(resolution))
pixels = [*0...width].cartesian_product([*0...height]).to_h { |x, y| {({x.to_i16, y.to_i16}), false} }
main_loop.each do |node|
  x, y = [node.x, node.y].map(&.*(resolution).+(1))
  pixels[{x, y}] = true
  pixels[{x, y - 1}] = true if node.chr == 'S' || node.ends.includes?(n)
  pixels[{x + 1, y}] = true if node.chr == 'S' || node.ends.includes?(e)
  pixels[{x, y + 1}] = true if node.chr == 'S' || node.ends.includes?(s)
  pixels[{x - 1, y}] = true if node.chr == 'S' || node.ends.includes?(w)
end

lines = ["# ImageMagick pixel enumeration: #{width},#{height},255,rgb"]
pixels.each { |(x, y), on| lines << "#{x},#{y}: #{on ? "(0,0,0)" : "(255,255,255)"}" }
File.write("day10.txt", lines.join("\n"))

`convert txt:day10.txt -fill red -draw 'color 0,0 floodfill' +write day10_img.png`

p (grid.values.flat_map(&.values) - main_loop).count { |node|
  x, y = [node.x, node.y].map(&.*(resolution).+(1))
  `magick day10_img.png -format "%[hex:u.p{#{x},#{y}}]" info:` =~ /FFFFFF/
}
