// $ kotlinc day22_1.kt -include-runtime -d 221.jar && java -jar 221.jar

import kotlin.math.sqrt

val input = """
  ... paste input here ...
""".trimIndent()

data class Position(val x: Int, val y: Int)

data class Node(var infected: Boolean = false)

class Grid : HashMap<Position, Node> {
  constructor(fromInput: String) : super() {
    fromInput.split("\n").forEachIndexed { y, line ->
      line.toCharArray().forEachIndexed { x, char ->
        put(Position(x, y), Node(infected = (char == '#')))
      }
    }
  }
}

fun Grid.fetch(position: Position): Node {
  var node = get(position)
  if (node == null) {
    node = Node()
    put(position, node)
  }
  return node
}

val Grid.center: Position
  get() {
    val halfWidth = (sqrt(size.toFloat()) / 2).toInt()
    return Position(halfWidth, halfWidth)
  }

class Cursor(var x: Int, var y: Int,
             var direction: Int = 0,
             var infectionsCaused: Int = 0) {
  fun hauntGrid(grid: Grid, visitations: Int = 1) {
    repeat(visitations) {
      val nextNode = grid.fetch(Position(x, y))
      hauntNode(nextNode)
      move()
    }
  }

  fun hauntNode(node: Node) {
    if (node.infected) {
      turnRight()
    }
    else {
      turnLeft()
      this.infectionsCaused++
    }
    node.infected = !node.infected
  }

  fun turnRight() {
    if (direction > 2) this.direction = 0
    else               this.direction++
  }

  fun turnLeft() {
    if (direction < 1) this.direction = 3
    else               this.direction--
  }

  fun move() = when (direction) {
    0 -> this.y-- // N
    1 -> this.x++ // E
    2 -> this.y++ // S
    3 -> this.x-- // W
    else -> throw IllegalArgumentException("bad direction ${direction}")
  }
}

fun main(args: Array<String>) {
  val grid = Grid(fromInput = input)
  val cursor = Cursor(grid.center.x, grid.center.y)
  cursor.hauntGrid(grid, visitations = 10000)

  println("Infections caused: ${cursor.infectionsCaused}")
}
