f = __FILE__.sub(/\d\..*/, "input")

p File.read(f).scan(/\d+/).each_slice(9).to_a.reduce(0) { |sum, md_group|
  sum + md_group
    .map(&.[0].to_i)
    .each_slice(3).to_a
    .transpose
    .count { |(a, b, c)| a + b > c && a + c > b && b + c > a }
#             ^ unlike Ruby, parens are obligatory for arg destructuring
}
