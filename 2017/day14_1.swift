// $ cat day10_2.swift day14_1.swift | swift -

extension String {
  func toNibbleString() -> String {
    func pad(_ string: String) -> String {
      var padded = string
      for _ in 0..<(4 - string.count) { padded = "0" + padded }
      return padded
    }

    return self.reduce("") { (acc, chr) -> String in
      let intValue = UInt8(String(chr), radix: 16)
      let binaryValue = String(intValue ?? 0, radix: 2)
      return acc + pad(binaryValue)
    }
  }

  func countOnes() -> Int {
    var count = 0
    for chr in self {
      if String(chr) == "1" { count += 1 }
    }
    return count
  }
}

func countUsedSquares() -> Int {
  var used = 0
  for i in 0...127 {
    let knotHash = hashFor(defragmentationInput() + "-" + String(i))
    used += knotHash.toNibbleString().countOnes()
  }
  return used
}

func defragmentationInput() -> String {
  return "... paste input here ..."
}

print(countUsedSquares())
