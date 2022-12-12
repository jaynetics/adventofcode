f = __FILE__.sub(/(day..).*/, '\1_input')

require 'benchmark'
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

edges = graph.instance_variable_get(:@edges)

bfs_depth = ->(from_pos:, to_pos:) do
  queue = [from_pos]
  seen = { from_pos => true }
  depth = 1

  while !queue.empty? do
    queue.size.times do
      pos = queue.shift
      edges[pos]&.each do |adj_pos,|
        seen.key?(adj_pos) ? next : seen.store(adj_pos, true)

        if adj_pos == to_pos
          return depth
        else
          queue.push(adj_pos)
        end
      end
    end
    depth += 1
  end
end

# part 1
start = grid.index('S')
dest = grid.index('E')

Benchmark.bm do |x|
  x.report('1. Dijkstra: ') { p graph.shortest_distance(start, dest) }
  x.report('1. BFS: ') { p bfs_depth.(from_pos: start, to_pos: dest) }
end

# part 2
starts = grid.each_with_index.select { |e, _y, _x| e[/a|S/] }.each(&:shift)

Benchmark.bm do |x|
  x.report('2. Dijkstra: ') do
    p starts.map { |s| graph.shortest_distance(s, dest) rescue nil }.compact.min
  end
  x.report('2. BFS: ') do
    p starts.map { |s| bfs_depth.(from_pos: s, to_pos: dest) }.compact.min
  end
end
