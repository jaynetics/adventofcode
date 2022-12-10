f = __FILE__.sub(/\d\..*/, "input")

lines = File.read_lines(f)
width = lines.first.size
slopes = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]

hits_per_slope = slopes.map do |(x_move, y_move)|
  x = 0
  hits = 0

  lines.each_slice(y_move) do |slice|
    line = slice.first
    hits += 1 if line[x] == '#'
    x = (x + x_move) % width
  end

  hits
end

# note the `1_i64` - the default is Int32 which overflows for this
p hits_per_slope.reduce(1_i64) { |acc, el| acc * el }
