f = __FILE__.sub(/(day..)\K.*/, "_input")

MAP, INSTRUCTIONS = File.read(f).split("\n\n")

GRID = {}
R, D, L, U = '>', 'v', '<', '^'
DIRS = [R, D, L, U]

MAP.each_line(chomp: true).with_index do |line, row|
  GRID[row] = line.each_char.with_object({}).with_index do |(chr, acc), col|
    acc[col] = chr unless chr == ' '
  end
end

def run
  row = 0
  col = GRID[0].keys.find { |k| GRID[0][k] }
  dir = DIRS.first

  INSTRUCTIONS.scan(/\d+|\D/).each do |instruction|
    case instruction
    when 'R' then dir = DIRS[(DIRS.index(dir) + 1) % 4]
    when 'L' then dir = DIRS[(DIRS.index(dir) - 1) % 4]
    else
      row, col = move(row:, col:, dir:, steps: instruction.to_i)
    end
  end

  puts 1000 * (row + 1) + 4 * (col + 1) + DIRS.index(dir)
end

def move(row:, col:, dir:, steps:)
  steps.times do
    current_row, current_col = row, col

    case dir
    when R then col += 1
    when D then row += 1
    when L then col -= 1
    when U then row -= 1
    end

    if GRID[row]&.[](col).nil? # wrap around
      case dir
      when R then col = GRID[row].keys.first
      when D then row = GRID.keys.find { |k| GRID[k][col] }
      when L then col = GRID[row].keys.last
      when U then row = GRID.keys.reverse.find { |k| GRID[k][col] }
      end
    end

    return [current_row, current_col] if GRID[row][col] == '#'
  end

  [row, col]
end

run
