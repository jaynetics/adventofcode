f = __FILE__.sub(/\d\..*/, "input")

cols = File.read(f).split("\n").map(&.chars).transpose
puts cols.map { |col| col.max_by { |chr| col.count(chr) } }.join
