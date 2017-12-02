fun checksum(input: String): Int {
    return input.split("\n").fold(0, { sum, row ->
        val numbers = row.split("\t").map { it.toDouble() }.sorted()
        var rowResult = 0
        numbers.forEach { n ->
          numbers.forEach { m ->
            if (n > m && n % m == 0.0) { rowResult = (n / m).toInt() }
          }
        }
        sum + rowResult
    })
}
