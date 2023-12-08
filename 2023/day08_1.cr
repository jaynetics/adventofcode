# crystal build --release 2023/day08_1.cr && time ./day08_1

F = __FILE__.sub(/\d\..*/, "input")

INSTR = File.read_lines(F, chomp: true).first.chars.map(&.==('L'))
NODES = File.read(F).scan(/(...).*(...), (...)/).to_h { |(_, a, b, c)| {a, [b, c]} }

node = "AAA"

INSTR.cycle.with_index(1) do |go_left, i|
  l, r = NODES[node]
  node = go_left ? l : r
  break p(i) if node == "ZZZ"
end
