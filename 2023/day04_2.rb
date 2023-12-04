f = __FILE__.sub(/\d\..*/, 'input')

multipliers = Hash.new(1)

p File.foreach(f).with_index.sum { |line, i|
  _, win, own = line.split(/[:|]/).map { _1.scan(/\d+/) }
  match_count = (own & win).count
  multipliers[i].times do # Integer#times returns the integer ;)
    ((i + 1)..(i + match_count)).each { |j| multipliers[j] += 1 }
  end
}
