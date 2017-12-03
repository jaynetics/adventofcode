// $ kotlinc day15_2.kt -include-runtime -d 152.jar && java -jar 152.jar

import java.math.BigInteger

// the following 2 lines are the input:
val startA = BigInteger("699")
val startB = BigInteger("124")

val factorA = BigInteger("16807")
val targetDivA = BigInteger("4")
val factorB = BigInteger("48271")
val targetDivB = BigInteger("8")
val divisor = BigInteger("2147483647")

class Generator(var value: BigInteger, val factor: BigInteger,
                val targetDiv: BigInteger) {
  fun next(): BigInteger {
    do { this.run() } while (this.value.rem(this.targetDiv) != BigInteger.ZERO)
    return this.value
  }

  private fun run() {
    this.value = this.value.times(this.factor).rem(divisor)
  }
}

fun matchesIn(iterations: Int): Int {
  val genA = Generator(value = startA, factor = factorA, targetDiv = targetDivA)
  val genB = Generator(value = startB, factor = factorB, targetDiv = targetDivB)

  var matches = 0
  for (_i in 1..iterations) {
    val valA = genA.next()
    val valB = genB.next()

    if (lowest16Bits(valA) == lowest16Bits(valB)) matches += 1
  }
  return matches
}

fun lowest16Bits(value: BigInteger): String {
  val paddedString = "000000000000000" + value.toString(2)
  return paddedString.substring(paddedString.length - 16)
}

fun main(args: Array<String>) {
  println("matches: " + matchesIn(iterations = 5000000))
}
