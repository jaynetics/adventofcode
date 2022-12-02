let stepSize = Int("... paste input here ...")!

var buffer = [0]
var cursor = 0

for n in 1...2017 {
  cursor = (cursor + stepSize + 1) % n
  buffer.insert(n, at: cursor)
}

print(buffer[cursor + 1])
