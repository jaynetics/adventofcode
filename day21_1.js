const start = '.#./..#/###',
      iterations = 5,
      input = `... paste input here ...`.trim()

class Matrix extends Array {
  static fromString(string) {
    return new Matrix(...string.match(/[#.]/g))
  }

  static fromSections(sections) {
    const sectionCount = sections.length
    if (sectionCount == 1) return sections[0]

    const matrix = new Matrix(),
          matrixLength = sectionCount * sections[0].length,
          matrixSize = Math.sqrt(matrixLength),
          gridSize = Math.sqrt(sectionCount),
          sectionSize = sections[0].size

    for (let i = 0; i < matrixLength; i++) {
      let {x, y} = Matrix.positionFor({index: i, size: matrixSize}),
          gridX = Math.floor(x / sectionSize),
          gridY = Math.floor(y / sectionSize),
          gridIndex = Matrix.indexFor({x: gridX, y: gridY, size: gridSize}),
          section = sections[gridIndex],
          sectionX = x % sectionSize,
          sectionY = y % sectionSize,
          idx = Matrix.indexFor({x: sectionX, y: sectionY, size: sectionSize})

      matrix.push(section[idx])
    }

    return matrix
  }

  static positionFor({index, size}) {
    return {x: index % size, y: Math.floor(index / size)}
  }

  static indexFor({x, y, size}) {
    return y * size + x
  }

  equals(otherMatrix) {
    return JSON.stringify(this) === JSON.stringify(otherMatrix)
  }

  elementAtPosition({x, y}) {
    return this[this.indexForPosition({x: x, y: y})]
  }

  indexForPosition({x, y}) {
    return Matrix.indexFor({x: x, y: y, size: this.size})
  }

  positionForIndex(index) {
    return Matrix.positionFor({index: index, size: this.size})
  }

  get size() {
    return Math.sqrt(this.length)
  }

  getPermutations() {
    return [this,                      this.flip(),
            this.turn(),               this.turn().flip(),
            this.turn().turn(),        this.turn().turn().flip(),
            this.turn().turn().turn(), this.turn().turn().turn().flip()]
  }

  flip() {
    return this.convertPositions(({x, y}) =>
      this.indexForPosition({x: this.size - x - 1, y: y}))
  }

  turn() {
    return this.convertPositions(({x, y}) =>
      this.indexForPosition({x: this.size - y - 1, y: x}))
  }

  convertPositions(newIndexFunc) {
    const conversion = new Matrix()
    this.forEach((e, i) => {
      let newIndex = newIndexFunc(this.positionForIndex(i))
      conversion[newIndex] = e
    })
    return conversion
  }

  getSections() {
    const sectionCount = this.sectionCount
    if (sectionCount == 1) return [this]

    const sections = [],
          sectionSize = this.sectionSize,
          gridSize = Math.sqrt(sectionCount)

    for (let i = 0; i < sectionCount; i++) {
      let section = new Matrix(),
          gridPosition = Matrix.positionFor({index: i, size: gridSize})

      for (let sectionY = 0; sectionY < sectionSize; sectionY++) {
        for (let sectionX = 0; sectionX < sectionSize; sectionX++) {
          let parentX = gridPosition.x * sectionSize + sectionX
          let parentY = gridPosition.y * sectionSize + sectionY
          section.push(this.elementAtPosition({x: parentX, y: parentY}))
        }
      }
      sections.push(section)
    }

    return sections
  }

  get sectionCount() {
    return this.length / (this.sectionSize ** 2)
  }

  get sectionSize() {
    return this.size % 2 == 0 ? 2 : 3
  }
}

class Rule {
  constructor(src, dst) {
    this.src = Matrix.fromString(src)
    this.dst = Matrix.fromString(dst)
  }

  static fromString(string) {
    return new Rule(...string.split(' => '))
  }
}

class RuleSet {
  constructor(rules) {
    this.rules = rules
  }

  outputFor(matrix) {
    const permutations = matrix.getPermutations(),
          rule = this.rules.find(r => permutations.some(p => r.src.equals(p)))
    return rule.dst
  }
}

const ruleSet = new RuleSet(input.split("\n").map(line => Rule.fromString(line)))
let matrix = Matrix.fromString(start)

for (let i = 0; i < iterations; i++) {
  let updatedSections = matrix.getSections().map(s => ruleSet.outputFor(s))
  matrix = Matrix.fromSections(updatedSections)
}

console.log(`on: ${matrix.filter(e => e === '#').length} of ${matrix.length}`)
