f = __FILE__.sub(/\d\..*/, 'input')

p File.foreach(f).inject(0) { |sum, line|
  line.chomp!
  part1, part2 = line.scan(/.{#{line.length / 2}}/)
  ord = part1.each_char.find { |c| part2[c] }.ord
  sum + ord - (ord > 96 ? 96 : 38)
}
