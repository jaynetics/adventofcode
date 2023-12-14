f = __FILE__.sub(/(day..).*/, '\1_input')

require 'matrix'

grid = Matrix[*File.readlines(f, chomp: true).reject(&:empty?).map(&:chars)]

class Matrix
  def roll(dir)
    vectors = send(dir == :n || dir == :s ? :column_vectors : :row_vectors)
    new_vectors = vectors.map do |v|
      reverse = dir == :n || dir == :w
      rolled = v.to_a.join.gsub(reverse ? /\.[.O]*O/ : /O[.O]*\./) do
        $&.chars.sort_by { reverse ? -_1.ord : _1.ord }.join
      end
      Vector[*rolled.chars]
    end
    Matrix.send(dir == :n || dir == :s ? :columns : :rows, new_vectors)
  end

  def score = row_count.downto(1).zip(row_vectors).sum { _1 * _2.count('O') }
end

# part 1
puts grid.roll(:n).score

# part 2
iterations = 1_000_000_000

# detect cycles
seen_grids = {}
cycle_size, iteration = (1..).each do |i|
  grid = grid.roll(:n).roll(:w).roll(:s).roll(:e)
  prev_i, _ = seen_grids.find { _2 == grid }
  seen_grids[i] = grid
  break [i - prev_i, i] if prev_i
end

# skip cycles
iteration += cycle_size * ((iterations - iteration) / cycle_size)

loop do
  grid = grid.roll(:n).roll(:w).roll(:s).roll(:e)
  break p grid.score if (iteration += 1) == iterations
end
