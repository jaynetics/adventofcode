# crystal build --release 2022/day17_all.cr && time ./day17_all

F = __FILE__.sub(/(day..)\K.*/, "_input")

MOVES = File.read(F).chars.map { |c| c == '>' ? 1 : -1 }

SHAPE_STRS = <<-STR.chomp.split("\n\n")
####

.#.
###
.#.

..#
..#
###

#
#
#
#

##
##
STR

alias Shape = Array(Array(Int32))

SHAPES = SHAPE_STRS.each_with_object([] of Shape) do |str, acc|
  coords = Shape.new
  str.lines.each_with_index do |line, i|
    line.chars.each_with_index do |char, x|
      # pre-include x- & y-offset that shape has when appearing in grid
      char == '#' && coords << [x + 2, str.lines.size - i + 2]
    end
  end
  acc << coords
end

alias Grid = Hash(Int32, Hash(Int32, Bool))
alias CycleId = Tuple(Int8, Int32)
alias CycleInfo = Tuple(Int32, Int64, Int32)
alias CycleHistory = Hash(CycleId, Array(CycleInfo))

def drop(n)
  grid = Grid.new
  dropped = 0_i64
  shape = nil
  shape_idx = 0_i8
  move_idx = 0

  cycle_history = CycleHistory.new
  stubbed_height = 0_i64

  (0..).each do |tick|
    if !shape
      shape_idx = (dropped % SHAPES.size).to_i8
      shape = SHAPES[shape_idx].map(&.dup)
      shape.each { |coord| coord[1] += grid.size }
    end

    move_idx = tick % MOVES.size
    m = MOVES[move_idx]

    # check for cyclical behavior when back at same move and shape
    cycle_id = {shape_idx, move_idx}
    logged = cycle_history[cycle_id] ||= Array(CycleInfo).new
    if logged.size < 3
      logged << {tick, dropped.as(Int64), grid.size}
    elsif logged.size == 3 && stubbed_height == 0
      entry1, entry2, entry3 = logged.last(3)
      tick1, dropped1, height1 = entry1
      tick2, dropped2, height2 = entry2
      tick3, dropped3, height3 = entry3
      if (tick_gain = tick3 - tick2) == tick2 - tick1 &&
         (drop_gain = dropped3 - dropped2) == dropped2 - dropped1 &&
         (height_gain = height3 - height2) == height2 - height1
        puts "Cycle found! Shape #{shape_idx}, move #{move_idx}: " \
             "#{drop_gain} shapes in #{tick_gain} ticks for #{height_gain} height"

        n_left = n.to_i64 - dropped
        skippable_cycles = ((n_left - 1) / drop_gain.as(Int64)).to_i64
        dropped += skippable_cycles * drop_gain.as(Int64)
        stubbed_height += skippable_cycles * height_gain.as(Int32)
        puts "Skipped this cycle #{skippable_cycles} times!"
      end
    end

    # shape movement & collision detection

    if shape.all? { |(x, y)| nx = x + m; nx >= 0 && nx < 7 && !((row = grid[y]?) && row[nx]?) }
      # can move sideways
      shape.each { |coord| coord[0] += m }
    end

    if shape.all? { |(x, y)| y - 1 >= 0 && !((row = grid[y - 1]?) && row[x]?) }
      # can move down
      shape.each { |coord| coord[1] -= 1 }
    else
      # stuck - add to grid
      shape.each do |(x, y)|
        row = grid[y] ||= {} of Int32 => Bool
        row[x] = true
      end
      shape = nil
      break if (dropped += 1) == n
    end
  end

  grid.size.to_i64 + stubbed_height
end

# part 1
puts drop(2022)

# part 2
puts drop(1_000_000_000_000)
