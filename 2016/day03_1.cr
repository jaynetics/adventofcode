f = __FILE__.sub(/\d\..*/, "input")

p File.read_lines(f).count { |line|
  a, b, c = line.scan(/\d+/).map(&.[0].to_i) # nice short block syntax 😍
  a + b > c && a + c > b && b + c > a
}
