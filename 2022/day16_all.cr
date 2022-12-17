# crystal build -Dpreview_mt --release 2022/day16_all.cr && time ./day16_all

f = __FILE__.sub(/(day..)\K.*/, "_input")

# minor optimization: use integers for node lookup, not UTF8 strings
# (this actually reduces runtime by 30%)
ABC = [*'A'..'Z']
IDS = ABC.cartesian_product(ABC).map_with_index { |cs, i| {cs.join, i} }.to_h

VALUES = {} of Int32 => Int32
EDGES  = {} of Int32 => Array(Int32)

File.each_line(f) do |line|
  name, *adj_names = line.scan(/[A-Z]{2}/).map { |md| md[0] }
  value = line[/\d+/].to_i
  VALUES[IDS[name]] = value unless value == 0
  EDGES[IDS[name]] = adj_names.map { |n| IDS[n] }
end

NO_TOGGLE = [false]
BOTH      = [false, true]

def dig(
  node, targets = VALUES, actions_left = 30, tsize = targets.size, sum = 0,
  done = {} of Int32 => Bool, prev = nil, pprev = nil, ppprev = nil, prev_toggled = false,
  &block : Int32 -> Void
)
  (done[node]? || !(node_v = targets[node]?) ? NO_TOGGLE : BOTH).each do |toggle|
    if actions_left > 0 && toggle
      actions_left -= 1
      sum += (node_v || 0) * actions_left
      done = done.merge({node => true})
    end

    # "optimization": stop if no valuable nodes are left
    if actions_left == 0 || done.size == tsize
      yield sum
    else
      EDGES[node].each do |adj|
        # optimization: prevent passive A-B-A and A-B-C-B-A routes
        next if !toggle && (prev == adj || ppprev == adj && !prev_toggled)

        dig(adj, targets, actions_left - 1, tsize, sum, done, node, prev, pprev, toggle, &block)
      end
    end
  end
end

# part 1 (takes ~ 10 sec)
start = IDS["AA"]
best = 0
dig(start) { |result| best = result if result > best }
puts "part 1: #{best}"

# part 2 - yeah, lets do it like a total barbarian
CORES = 6

# find all ways to split the nodes into roughly equal pairs
half_size = (VALUES.size / 2).to_i
nodes = VALUES.keys.sort
splits = [] of Array(Hash(Int32, Int32))
# can't be assed to do this part, so stochastics it is. takes 1 sec.
400_000.times do
  a = nodes.sample(half_size + [-1, 0, 1].sample).sort
  splits << [a, nodes - a].sort
end
splits.uniq!

print "#{splits.size} splits"

best = 0
channel = Channel(Int32).new

# takes ~15 min
splits.each_slice((splits.size / CORES).ceil.to_i).each_with_index do |slice, i|
  spawn(name: "Thread #{i + 1}") do
    slice.each do |(a, b)|
      best_a = 0
      best_b = 0
      dig(start, a, 26) { |res| best_a = res if res > best_a }
      dig(start, b, 26) { |res| best_b = res if res > best_b }
      channel.send(best_a + best_b)
    end
  end
end

splits.size.times do
  res = channel.receive
  best = res if res > best
  print '.'
end

puts "part 2: #{best}"
