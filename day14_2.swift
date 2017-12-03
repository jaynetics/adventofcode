// $ cat day10_2.swift day14_2.swift | swift -

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
}

class GridPoint {
  var active: Bool
  var cartographed: Bool
  var x: Int
  var y: Int

  init(active: Bool, cartographed: Bool, x: Int, y: Int) {
    self.active = active
    self.cartographed = cartographed
    self.x = x
    self.y = y
  }

  func needsCartographing() -> Bool {
    return self.active && !self.cartographed
  }

  func cartograph(inGrid grid: [[GridPoint]]) {
    self.cartographed = true

    for (nx, ny) in [(self.x-1, self.y), (self.x, self.y-1),
                     (self.x+1, self.y), (self.x, self.y+1)] {
      if (0...127 ~= nx && 0...127 ~= ny) {
        let neighbor = grid[ny][nx]
        if (neighbor.needsCartographing()) { neighbor.cartograph(inGrid: grid) }
      }
    }
  }
}

func countRegions() -> Int {
  let grid = buildGrid()
  var regions = 0

  for row in grid {
    for square in row {
      if (square.needsCartographing()) {
        square.cartograph(inGrid: grid)
        regions += 1
      }
    }
  }
  return regions
}

func buildGrid() -> [[GridPoint]] {
  var grid = [[GridPoint]]()

  for y in 0...127 {
    let knotHash = hashFor(defragmentationInput() + "-" + String(y))
    let row = knotHash.toNibbleString().enumerated().map { (x, chr) in
      return GridPoint(active: chr == "1", cartographed: false, x: x, y: y)
    }
    grid.append(row)
  }

  return grid
}

func defragmentationInput() -> String {
  return "... paste input here ..."
}

print(countRegions())
