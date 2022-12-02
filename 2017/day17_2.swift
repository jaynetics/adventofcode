let stepSize = Int("... paste input here ...")!

var cursor = 0
var valueOne = 0

for n in 1...50000000 {
  cursor = (cursor + stepSize + 1) % n
  if (cursor == 0) { valueOne = n }
}

print(valueOne)
