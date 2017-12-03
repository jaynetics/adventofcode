// uncomment last line to make this print something (disabled for day14)

let dataSize = 256
let repetitions = 64
let salt = [17, 31, 73, 47, 23]

func hashFor(_ input: String) -> String {
  var data = [Int](0..<dataSize)
  let lengths = input.map {Int($0.unicodeScalars.first?.value ?? 0)} + salt

  var pos = 0
  var skip = 0

  for _ in 1...repetitions {
    for length in lengths {
      for n in 0..<(length/2) {
        let (i1, i2) = loopedIndexPair(n, from: pos, to: length + pos)
        data.swapAt(i1, i2)
      }
      pos = (pos + skip + length) % dataSize
      skip += 1
    }
  }

  return denseHash(data)
}

func loopedIndexPair(_ n: Int, from: Int, to: Int) -> (Int, Int) {
  return ((from + n) % dataSize, (to - n - 1) % dataSize)
}

func denseHash(_ data: [Int]) -> String {
  var xoredNumbers = [Int]()

  for i in stride(from: 0, to: dataSize, by: 16) {
    let dataSlice = data[i...(i + 15)]
    xoredNumbers.append(xorJoin(dataSlice))
  }

  return hexString(xoredNumbers)
}

func xorJoin(_ ints: ArraySlice<Int>) -> Int {
  var result: Int?
  for i in ints {
    if (result == nil) { result = i }
    else               { result = result! ^ i }
  }
  return result!
}

func hexString(_ numbers: [Int]) -> String {
  return numbers
    .map {
      let string = String($0, radix: 16, uppercase: false)
      return string.count == 1 ? "0" + string : string
    }
    .joined(separator: "")
}

func initialInput() -> String {
  return """
... paste input here ...
"""
}

// print(hashFor(initialInput()))
