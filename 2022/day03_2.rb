f = __FILE__.sub(/\d\..*/, 'input')

group = []
p File.foreach(f).inject(0) { |sum, line|
  group << line.chomp
  next sum if group.size < 3

  ord = group[0].each_char.find { |c| group[1][c] && group[2][c] }.ord
  group.clear
  sum + ord - (ord > 96 ? 96 : 38)
}
