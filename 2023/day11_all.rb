f = __FILE__.sub(/(day..).*/, '\1_input')

rows = File.readlines(f, chomp: true).reject(&:empty?).map(&:chars)
cols = rows.transpose.map(&:reverse)
empty_rows = rows.each_with_index.to_h { |row, i| [i, !row.include?('#')] }
empty_cols = cols.each_with_index.to_h { |col, i| [i, !col.include?('#')] }
points = rows.each_with_index.with_object([]) do |(row, y), acc|
  row.each_with_index { |c, x| acc << [x, y] if c == '#' }
end
pairs = points.combination(2).to_a.sort

calc = ->(exp) do
  pairs.sum { |(x1, y1), (x2, y2)|
    x1, x2 = [x1, x2].sort
    y1, y2 = [y1, y2].sort
    add = ((y1 + 1)...y2).count { |y| empty_rows[y] } * (exp - 1) +
          ((x1 + 1)...x2).count { |x| empty_cols[x] } * (exp - 1)
    x2 - x1 + y2 - y1 + add
  }
end

# part 1
p calc.(2)

# part 2
p calc.(1_000_000)
