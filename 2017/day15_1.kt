// $ kotlinc day15_1.kt -include-runtime -d 151.jar && java -jar 151.jar

import java.math.BigInteger

// the following 2 lines are the input:
val startA = BigInteger("699")
val startB = BigInteger("124")

val factorA = BigInteger("16807")
val factorB = BigInteger("48271")
val divisor = BigInteger("2147483647")

class Generator(var value: BigInteger, val factor: BigInteger) {
  fun next(): BigInteger {
    this.value = this.value.times(this.factor).rem(divisor)
    return this.value
  }
}

fun matchesIn(iterations: Int): Int {
  val genA = Generator(value = startA, factor = factorA)
  val genB = Generator(value = startB, factor = factorB)

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
  println("matches: " + matchesIn(iterations = 40000000))
}
