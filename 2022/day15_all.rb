f = __FILE__.sub(/(day..).*/, '\1_input')

Node = Struct.new(:x, :y, :reach)
SENSOR_GRID = {} # Hash to support random and non-contiguous coords
BEACON_GRID = {}

File.foreach(f) do |line|
  sx, sy, bx, by = line.scan(/-?\d+/).map(&:to_i)
  reach = (sx - bx).abs + (sy - by).abs
  (SENSOR_GRID[sy] ||= {})[sx] = Node.new(sx, sy, reach)
  (BEACON_GRID[by] ||= {})[bx] = Node.new(bx, by, nil)
end

def sensor_ranges(y)
  SENSOR_GRID.each_value.with_object([]) do |row, acc|
    row.each_value do |node|
      distance = (node.y - y).abs
      loc_reach = node.reach - distance
      acc << ((node.x - loc_reach)..(node.x + loc_reach)) if loc_reach > 0
    end
  end
end

# part 1
def scan_count_in_row(y)
  scanned = {}
  sensor_ranges(y).each { |range| range.each { |x| scanned[x] = true } }
  # don't count sensors and beacons
  scanned.size - SENSOR_GRID[y]&.size.to_i - BEACON_GRID[y]&.size.to_i
end

puts scan_count_in_row(2_000_000)

# part 2
LIMIT = 4_000_000

def find_free_x(y)
  ranges = sensor_ranges(y).sort_by(&:begin)
  ranges.each do |r1|
    pre = r1.begin - 1
    pst = r1.end + 1
    next unless pre.between?(0, LIMIT) && pst.between?(0, LIMIT)

    pre_covered = false
    pst_covered = false
    ranges.each do |r2|
      pre_covered = true if r2.cover?(pre)
      pst_covered = true if r2.cover?(pst)
      break if pre_covered && pst_covered
    end
    return pre unless pre_covered
    return pst unless pst_covered
  end
  nil
end

(0..LIMIT).each do |y|
  x = find_free_x(y)
  x and break puts(x:, y:, solution: x * 4_000_000 + y)
end
