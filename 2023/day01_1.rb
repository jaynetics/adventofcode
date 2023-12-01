f = __FILE__.sub(/\d\..*/, 'input')

p File.foreach(f).sum { "#{_1[/\d/]}#{_1[/.*\K\d/]}".to_i }

