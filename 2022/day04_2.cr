f = __FILE__.sub(/\d\..*/, "input")

p File.read(f).lines.count { |l|
  r1, r2 = l.scan(/(\d+)-(\d+)/).map { |m| (m[1].to_i)..(m[2].to_i) }
  r1.covers?(r2.first) || r2.covers?(r1.first)
}
