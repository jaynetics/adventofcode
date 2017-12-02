fun checksum(input: String): Int {
    return input.split("\n").fold(0, { sum, row ->
        val numbers = row.split("\t").map { it.toInt() }.sorted()
        sum + numbers.last() - numbers.first()
    })
}
