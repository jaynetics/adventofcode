# crystal build --release 2023/day09_all.cr && time ./day09_all

f = __FILE__.sub(/(day..)\K.*/, "_input")

rows = File.read_lines(f).reject(&.empty?).map(&.split(' ').map(&.to_i32))

def find_row_levels(row, acc = [] of Array(Int32))
  acc << row
  level = row[0..-2].map_with_index { |num, i| row[i + 1] - num }
  find_row_levels(level, acc) if (level - [0]).any?
  acc
end

row_levels = rows.map { |row| find_row_levels(row) }

# part 1
p row_levels.sum(&.sum(&.last))

# part 2
p row_levels.sum(&.reverse.reduce(0) { |acc, lvl| lvl[0] - acc })
