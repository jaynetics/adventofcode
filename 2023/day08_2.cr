# crystal build --release 2023/day08_2.cr && time ./day08_2

F = __FILE__.sub(/\d\..*/, "input")

INSTR = File.read_lines(F, chomp: true).first.chars.map(&.==('L'))
NODES = File.read(F).scan(/(...).*(...), (...)/).to_h { |(_, a, b, c)| {a, [b, c]} }

def find_cycle(node, step = 0, cycle_len = 1, prev_len = -1)
  go_left = INSTR[step % INSTR.size]
  l, r = NODES[node]
  node = go_left ? l : r

  if node.ends_with?("Z")
    return {step + 1, prev_len} if prev_len == cycle_len

    find_cycle(node, step + 1, 1, cycle_len)
  else
    find_cycle(node, step + 1, cycle_len + 1, prev_len)
  end
end

cycles = NODES.keys.select(&.ends_with?("A")).map { |n| find_cycle(n) }
cycles.each { |(steps, len)| raise("cycle has offset") if steps % len != 0 }
p cycles.map(&.last).reduce { |a, b| a.to_i64.lcm(b.to_i64) }
