f = __FILE__.sub(/\d\..*/, "input")

grid = <<-STR

    1
   234
  56789
   ABC
    D

STR

moves = {'R' => {:x, 1}, 'L' => {:x, -1}, 'U' => {:y, 1}, 'D' => {:y, -1}}
cursor = {:x => 2, :y => 3}
reverse_lines = grid.lines.reverse
value = ->(cursor : Hash(Symbol, Int32)) do
  # note the use of #[]? which is needed to allow the return value nil
  reverse_lines[cursor[:y]]?
    .to_s[cursor[:x]]?
    .to_s[/\S/]?
end

acc = [] of String

File.each_line(f) { |line|
  line.chomp.each_char do |c|
    a, n = moves[c]
    cursor[a] += n if value.call(cursor.dup.tap { |c| c[a] += n })
  end
  acc << value.call(cursor).to_s
}

puts acc.join
