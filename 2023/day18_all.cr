# crystal build --release 2023/day18_all.cr && time ./day18_all

F = __FILE__.sub(/(day..)\K.*/, "_input")

alias Instr = Tuple(String, Int32, String)
instr = File.read(F).scan(/(.) (\d+).*#(\w+)/).map { |(_, d, n, c)| {d, n.to_i, c}.as(Instr) }

def find_bounds(instr)
  lo_x = hi_x = lo_y = hi_y = 0

  each_vertice(instr) do |(x1, y1), (x2, y2), _color|
    lo_x, hi_x = [lo_x, hi_x, x1, x2].minmax
    lo_y, hi_y = [lo_y, hi_y, y1, y2].minmax
  end

  x_offset, y_offset = [[0, -lo_x].max, [0, -lo_y].max]
  max_x, max_y = [hi_x + x_offset, hi_y + y_offset]
  [x_offset, y_offset, max_x, max_y]
end

def each_vertice(instr : Array(Instr), start = {0, 0}, &)
  instr.reduce(start) do |xy, (d, n, color)|
    nxy = {xy[0] + (d.count('R') - d.count('L')) * n, xy[1] + (d.count('D') - d.count('U')) * n}
    yield xy, nxy, color
    nxy
  end
end

def each_xy(x1, y1, x2, y2, &)
  x1, x2 = [x1, x2].sort
  y1, y2 = [y1, y2].sort
  (x1..x2).each { |x| (y1..y2).each { |y| yield x, y } }
end

# part 1 - draw a nice image
x_offset, y_offset, max_x, max_y = find_bounds(instr)
pixels = Hash(Tuple(Int32, Int32), String).new("255,255,255")

each_vertice(instr, {x_offset, y_offset}) do |xy1, xy2, color|
  each_xy(*xy1, *xy2) do |x, y|
    pixels[{x, y}] = color.scan(/(..)/).map { |(_, g)| g.to_i(16).to_s.as(String) }.join(',')
  end
end

lines = ["# ImageMagick pixel enumeration: #{max_x + 1},#{max_y + 1},255,rgb"]
each_xy(0, 0, max_x, max_y) { |x, y| lines << "#{x},#{y}: (#{pixels[{x, y}]})" }

File.write("day18.txt", lines.join("\n"))

`convert txt:day18.txt -fill gray -draw 'color #{max_x/2},#{max_y/2} floodfill' +write day18_img.png`

p `convert day18_img.png txt:-`.lines.count { |l| l =~ /#(?!F{6})\w{6}/ }

# part 2

# I thought this would be one where we draw an even nicer image 😭
# There seem to be no non-algorithmic shortcuts either.
# All moves are unique, both R/L and U/D moves have gcd 1, corners touch, ...

dirs = {"R", "D", "L", "U"}
instr2 = File.read(F).scan(/#(\w+)(\w)/).map do |(_, h1, h2)|
  {dirs[h2.to_i], h1.to_i(16), ""}.as(Instr)
end

x_offset, y_offset, max_x, max_y = find_bounds(instr2)
grid = (0..max_y).to_h { |y| {y, {} of Int32 => Bool} }
depth = 0.0

each_vertice(instr2, {x_offset, y_offset}) do |(x1, y1), (x2, y2), _|
  each_xy(x1, y1, x2, y2) { |x, y| grid[y][x] = true }
  depth += 0.5 * (y1 + y2) * (x1 - x2) # shoelace formula
end

p depth.abs.to_i64 + (grid.values.sum(&.size) / 2).to_i + 1
