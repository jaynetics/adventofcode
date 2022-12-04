f = __FILE__.sub(/\d\..*/, "input")

p File.read(f).lines.count { |l|
  r1, r2 = l.scan(/(\d+)-(\d+)/).map { |m| (m[1].to_i)..(m[2].to_i) }
  # there is Range#covers?, but it's just an alias for #includes? :~(
  r1.begin >= r2.begin && r1.end <= r2.end ||
    r2.begin >= r1.begin && r2.end <= r1.end
}
