f = __FILE__.sub(/\d\..*/, "input")

count = 0

File.each_line(f) do |line|
  next unless m = /(?<min>\d+)-(?<max>\d+) (?<chr>\S): (?<pw>\S+)/.match(line)

  uses = m["pw"].count(m["chr"])
  # no Integer#between? in crystal :~(
  count += 1 if uses >= m["min"].to_i && uses <= m["max"].to_i
end

p count
