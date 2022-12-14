f = __FILE__.sub(/(day..).*/, '\1_input')

require 'matrix'

INSTRUCTIONS = File.foreach(f).map { |l| eval "[[#{l.gsub('->', '],[')}]]" }
MIN_Y, MAX_Y = 0, INSTRUCTIONS.flat_map { |i| i.map(&:last) }.max
MIN_X, MAX_X = INSTRUCTIONS.flat_map { |i| i.map(&:first) }.minmax
SOURCE_Y = 0
SOURCE_X = 500

def build_grid
  grid = Matrix.build(MAX_Y + 3, (MAX_X * 1.5).to_i) { '.' }

  # draw solids
  INSTRUCTIONS.each do |instruction|
    instruction.each_cons(2) do |(x1, y1), (x2, y2)|
      y_range = Range.new(*[y1, y2].sort)
      x_range = Range.new(*[x1, x2].sort)
      grid[y_range, x_range] = '#'
    end
  end

  # draw source
  grid[SOURCE_Y, SOURCE_X] = '+'

  grid
end

def next_sand_pos(grid, boxed: true)
  y = SOURCE_Y
  x = SOURCE_X

  loop do
    next_y = y + 1
    return false if boxed && next_y > MAX_Y # found hole in bottom

    next_x = [x, x - 1, x + 1].find do |next_x|
      return false if boxed && !next_x.between?(MIN_X, MAX_X) # crossed edge

      grid[next_y, next_x] == '.'
    end
    break unless next_x

    y = next_y
    x = next_x
  end

  [y, x]
end

# part 1
grid = build_grid

(0..).each do |n|
  pos = next_sand_pos(grid) or break puts(n)
  grid[*pos] = 'o'
  # puts grid.row_vectors.map { _1.to_a.join }, '' # zoom out a lot to view :D
end

# part 2
grid = build_grid

(0..).each do |n|
  grid[MAX_Y + 2, 0..] = '#'
  pos = next_sand_pos(grid, boxed: false)
  break puts(n + 1) if pos == [SOURCE_Y, SOURCE_X]
  grid[*pos] = 'o'
  # puts grid.row_vectors.map { _1.to_a.join }, '' # zoom out a lot to view :D
end
