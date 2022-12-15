# crystal build --release 2022/day15_all.cr && ./day15_all

f = __FILE__.sub(/(day..)\K.*/, "_input")

SENSORS = [] of Array(Int32)
BEACONS = [] of Array(Int32)

File.each_line(f) do |line|
  sx, sy, bx, by = line.scan(/-?\d+/).map { |md| md[0].to_i }
  sreach = (sx - bx).abs + (sy - by).abs
  SENSORS << [sx, sy, sreach]
  BEACONS << [bx, by]
end

def sensor_ranges(y)
  SENSORS.each_with_object([] of Range(Int32, Int32)) do |(sx, sy, sreach), acc|
    distance = (sy - y).abs
    loc_reach = sreach - distance
    acc << ((sx - loc_reach)..(sx + loc_reach)) if loc_reach > 0
  end
end

# part 1
def scan_count_in_row(y)
  scanned = {} of Int32 => Bool
  sensor_ranges(y).each { |range| range.each { |x| scanned[x] = true } }
  # don't count sensors and beacons
  scanned.size - (SENSORS + BEACONS.uniq).count { |(_, node_y)| node_y == y }
end

puts scan_count_in_row(2_000_000)

# part 2
LIMIT = 4_000_000

def find_free_x(y)
  ranges = sensor_ranges(y).sort_by(&.begin)
  ranges.each do |r1|
    pre = r1.begin - 1
    next unless pre >= 0 && pre <= LIMIT

    pst = r1.end + 1
    next unless pst >= 0 && pst <= LIMIT

    pre_covered = false
    pst_covered = false
    ranges.each do |r2|
      pre_covered ||= r2.covers?(pre)
      pst_covered ||= r2.covers?(pst)
      break if pre_covered && pst_covered
    end
    return pre unless pre_covered
    return pst unless pst_covered
  end
  nil
end

(0..LIMIT).each do |y|
  x = find_free_x(y)
  x && break puts({x: x, y: y, solution: x.to_i64 * 4_000_000 + y})
end
