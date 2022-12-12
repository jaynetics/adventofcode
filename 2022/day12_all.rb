f = __FILE__.sub(/(day..).*/, '\1_input')

require 'matrix'
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'dijkstra_fast'
end

grid = Matrix.rows(File.readlines(f, chomp: true).map(&:chars))
z_values = [*'a'..'z', 'S', 'E'].zip([*'a'..'z', 'a', 'z'].map(&:ord)).to_h

graph = DijkstraFast::Graph.new

grid.each_with_index do |e, y, x|
  [[y, x + 1], [y, x - 1], [y + 1, x], [y - 1, x]].each do |ny, nx|
    adjacent = grid[ny, nx] || next
    graph.add([y, x], [ny, nx]) if z_values[e] + 1 >= z_values[adjacent]
  end
end

# part 1
p graph.shortest_distance(grid.index('S'), grid.index('E'))

# part 2 - meh ... breadth-first might have been better here
p grid.each_with_index.map { |e, y, x|
  next unless e == 'a' || e == 'S'
  graph.shortest_distance([y, x], grid.index('E')) rescue next
}.compact.min
