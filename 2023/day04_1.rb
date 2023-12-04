f = __FILE__.sub(/\d\..*/, 'input')

p File.foreach(f).sum { |line|
  _, win, own = line.split(/[:|]/).map { _1.scan(/\d+/) }
  (own & win).count.then { |n| n > 0 ? 2 ** (n - 1) : 0 }
}
