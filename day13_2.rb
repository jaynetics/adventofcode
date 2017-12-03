class Scanner
  attr_accessor :depth, :range, :severity, :position

  def initialize(depth, range)
    self.depth = depth
    self.range = range
    self.position = 0
    self.severity = depth * range
  end

  def simulate_move_count(n)
    moves_per_range = range - 1
    ranges_covered = n / moves_per_range
    relative_position = n % moves_per_range
    self.position =
      if ranges_covered.even?
        relative_position
      else
        moves_per_range - relative_position
      end
  end
end

def calculate_safe_delay
  delay = 10
  delay += 1 until safe?(delay)
  delay
end

def safe?(delay)
  @scanner_map ||= build_scanner_map
  @scanner_map.none? do |depth, scanner|
    scanner.simulate_move_count(delay + depth)
    scanner.position.zero?
  end
end

def build_scanner_map
  input.lines.each_with_object({}) do |line, hash|
    depth, range = line.split(': ').map(&:to_i)
    hash[depth] = Scanner.new(depth, range)
  end
end

def input
  <<-EOS
... paste input here ...
EOS
end

puts "safe delay: #{calculate_safe_delay}"
