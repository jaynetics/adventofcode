f = __FILE__.sub(/(day..).*/, '\1_input')

require 'matrix'

grid = Matrix[*File.readlines(f, chomp: true).map(&:chars)]
max_x = grid.column_size - 1
max_y = grid.row_size - 1

# part 1
p grid.each_with_index.count { |el, y, x|
  (0...x).all?            { |i| grid[y, i] < el } ||
    (0...y).all?          { |i| grid[i, x] < el } ||
    ((x + 1)..max_x).all? { |i| grid[y, i] < el } ||
    ((y + 1)..max_y).all? { |i| grid[i, x] < el }
}

# part 2
p (1...max_x).to_a.product((1...max_y).to_a).map { |x, y|
  el = grid[y, x]
  factors = { n: 0, e: 0, s: 0, w: 0 }

  (y - 1).downto(0)   { |i| factors[:n] += 1; break if grid[i, x] >= el }
  (x + 1).upto(max_x) { |i| factors[:e] += 1; break if grid[y, i] >= el }
  (y + 1).upto(max_y) { |i| factors[:s] += 1; break if grid[i, x] >= el }
  (x - 1).downto(0)   { |i| factors[:w] += 1; break if grid[y, i] >= el }

  factors.values.reduce(:*)
}.max
