let dataSize = 256

func run() {
  var data = [Int](0..<dataSize)
  let lengths = input().split {$0 == ","}.map {Int(String($0)) ?? 0}

  var pos = 0
  var skip = 0

  for length in lengths {
    for n in 0..<(length/2) {
      let (i1, i2) = loopedIndexPair(n, from: pos, to: length + pos)
      data.swapAt(i1, i2)
    }
    pos = (pos + skip + length) % dataSize
    skip += 1
  }

  print(data[0] * data[1])
}

func loopedIndexPair(_ n: Int, from: Int, to: Int) -> (Int, Int) {
  return ((from + n) % dataSize, (to - n - 1) % dataSize)
}

func input() -> String {
  return """
... paste input here ...
"""
}

run()
