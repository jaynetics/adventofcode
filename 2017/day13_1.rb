class Scanner
  attr_accessor :depth, :range, :severity, :position, :moving_back

  def initialize(depth, range)
    self.depth = depth
    self.range = range
    self.position = 0
    self.severity = depth * range
  end

  def move
    turn_if_at_bounds
    self.position += (moving_back ? -1 : 1)
  end

  private

  def turn_if_at_bounds
    at_bounds? && self.moving_back = !moving_back
  end

  def at_bounds?
    position == (moving_back ? 0 : range - 1)
  end
end

def calculate_severity
  severity = 0
  scanners = build_scanners
  0.upto(scanners.last.depth) do |own_depth|
    scanner = scanners.find { |s| s.depth == own_depth }
    severity += scanner.severity if scanner && scanner.position.zero?
    scanners.each(&:move)
  end
  severity
end

def build_scanners
  input.lines.map { |line| Scanner.new(*line.split(': ').map(&:to_i)) }
end

def input
  <<-EOS
... paste input here ...
EOS
end

puts "severity: #{calculate_severity}"
