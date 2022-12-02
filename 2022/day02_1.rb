f = __FILE__.sub(/\d\..*/, 'input')

p(File.foreach(f).map do |l|
  case l.chomp
  when 'A Z', 'B X', 'C Y' then 0
  when 'A X', 'B Y', 'C Z' then 3
  else 6
  end + " XYZ".index(l[2])
end.sum)
