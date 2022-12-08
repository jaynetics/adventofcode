f = __FILE__.sub(/(day..).*/, '\1_input')

grid = File.readlines(f, chomp: true).map(&:chars)
max_x = grid.first.size - 1
max_y = grid.size - 1
cols = {}

# part 1
p grid.each.with_index.sum { |row, y|
  row.each.with_index.count { |el, x|
    col = (cols[x] ||= grid.map { _1[x] })

    (0...x).all? { |lo_x| row[lo_x] < el } ||
      (0...y).all? { |lo_y| col[lo_y] < el } ||
      ((x + 1)..max_x).all? { |hi_x| row[hi_x] < el } ||
      ((y + 1)..max_y).all? { |hi_y| col[hi_y] < el }
  }
}

# part 2
max_score = 0

grid.each.with_index { |row, y|
  next if y == 0 || y == max_y

  row.each.with_index { |el, x|
    next if x == 0 || x == max_x

    col = (cols[x] ||= grid.map { _1[x] })

    score =
      (x - 1).downto(0).inject(0) { |a, i| row[i] < el && a + 1 or break a + 1 } *
      (y - 1).downto(0).inject(0) { |a, i| col[i] < el && a + 1 or break a + 1 } *
      ((x + 1)..max_x).inject(0)  { |a, i| row[i] < el && a + 1 or break a + 1 } *
      ((y + 1)..max_y).inject(0)  { |a, i| col[i] < el && a + 1 or break a + 1 }

    max_score = score if score > max_score
  }
}

p max_score
