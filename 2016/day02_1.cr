f = __FILE__.sub(/\d\..*/, "input")

# The values in this Hash must be Tuples so that their elements
# can be used as indices without type ambiguity.
moves = {'R' => {:x, 1}, 'L' => {:x, -1}, 'U' => {:y, 1}, 'D' => {:y, -1}}
cur = {:x => 1, :y => 1}
acc = [] of String

File.each_line(f) do |line|
  line.each_char do |c|
    a, n = moves[c]
    a && n && (cur[a] = (cur[a] + n).clamp(0, 2))
  end
  acc << "#{7 + cur[:x] - cur[:y] * 3}"
end

puts acc.join
