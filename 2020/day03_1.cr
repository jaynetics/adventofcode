f = __FILE__.sub(/\d\..*/, "input")

x = 0
width = nil
hits = 0

File.each_line(f) do |line|
  width ||= line.size
  hits += 1 if line[x] == '#'
  x = (x + 3) % width
end

p hits
