f = __FILE__.sub(/day..\K.*/, "_input")

# OK, time for a Ruby getaway. This is just nicer with Matrix...
require 'matrix'

grid = Matrix.build(6, 50) { ' ' }

File.foreach(f) do |line|
  case line
  when /rect (\d+)x(\d+)/
    grid[0...$2.to_i, 0...$1.to_i] = '█'
  when /rotate row y=(\d+) by (\d+)/
    y = $1.to_i
    grid[y, 0..] = Vector[*grid.row(y).to_a.rotate(-$2.to_i)]
  when /rotate column x=(\d+) by (\d+)/
    x = $1.to_i
    grid[0.., x] = Vector[*grid.column(x).to_a.rotate(-$2.to_i)]
  end
end

puts grid.count('█') # part 1

puts grid.row_vectors.map { _1.to_a.join } # part 2
