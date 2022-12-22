f = __FILE__.sub(/(day..)\K.*/, "_input")

MAP, INSTRUCTIONS = File.read(f).split("\n\n")

# Assume a cube in a (not really dice-like) layout where side 1
# shall have axis x and y, 2,3,4,6 have z-depth, and 5 is the opposite.

X_forw, Y_forw, Z_forw, X_back, Y_back, Z_back =
DIRS = [[1, 0, 0], [0, 1, 0], [0, 0, 1], [-1, 0, 0], [0, -1, 0], [0, 0, -1]]

Face = Struct.new(:num, :dirs, :perpendicular) do
  def put(el, x:, y:, z:) = (@grid ||= {})[[x, y, z]] = el

  def get(x:, y:, z:) = @grid&.[]([x, y, z])

  def adj(dir)
    opposite_dir = DIRS[(DIRS.index(dir) + 3) % DIRS.size] || fail
    FACES.find { |f| f.perpendicular == opposite_dir } || fail
  end

  def turn_dir(dir, by) = dirs[(dirs.index(dir) + by) % 4]

  def to_s = "Face #{num}"
  alias inspect to_s

  def debug = @grid.values.each_slice(edge_len).map(&:join)
end

# faces with directions in face-local order "right, down, left, up".
F1, F2, F3, F4, F5, F6 =
FACES = [
  Face.new(num: 1, dirs: [X_forw, Y_back, X_back, Y_forw], perpendicular: Z_forw),
  Face.new(num: 2, dirs: [X_back, Z_forw, X_forw, Z_back], perpendicular: Y_back),
  Face.new(num: 3, dirs: [Y_back, Z_forw, Y_forw, Z_back], perpendicular: X_forw),
  Face.new(num: 4, dirs: [X_forw, Z_forw, X_back, Z_back], perpendicular: Y_forw),
  Face.new(num: 5, dirs: [X_forw, Y_forw, X_back, Y_back], perpendicular: Z_back),
  Face.new(num: 6, dirs: [Z_back, Y_forw, Z_forw, Y_back], perpendicular: X_back),
]

def run
  parse_map

  x = 0
  y = edge_len - 1
  z = 0
  dir = X_forw
  face = F1

  INSTRUCTIONS.scan(/\d+|\D/).each do |instruction|
    case instruction
    when 'R' then dir = face.turn_dir(dir, 1)
    when 'L' then dir = face.turn_dir(dir, -1)
    else
      x, y, z, dir, face = move(x:, y:, z:, dir:, face:, steps: instruction.to_i)
    end
  end

  face.put('X', x:, y:, z:) # mark last position

  state = { face:, x:, y:, z:, dir: }
  puts(**state, score: score(**state))
end

def parse_map(s = edge_len)
  lines = normalized_map.lines(chomp: true)
  lines[...s].each_with_index do |l, row|
    l[...s].chars.each_with_index        { |c, col| F1.put(c, x: col, y: s - row - 1, z: 0) }
  end
  lines[s...(s * 2)].each_with_index do |l, row|
    l[...s].chars.each_with_index        { |c, col| F2.put(c, x: s - col - 1, y: s - 1, z: row) }
    l[s...(s * 2)].chars.each_with_index { |c, col| F3.put(c, x: 0, y: s - col - 1, z: row) }
    l[(s * 2)...].chars.each_with_index  { |c, col| F4.put(c, x: col, y: 0, z: row) }
  end
  lines[(s * 2)..].each_with_index do |l, row|
    l[...s].chars.each_with_index        { |c, col| F5.put(c, x: col, y: row, z: s - 1) }
    l[s...].chars.each_with_index        { |c, col| F6.put(c, x: s - 1, y: row, z: s - col - 1) }
  end
end

# faces are arranged differently in input vs example. nice.
def normalized_map
  case f = folding_scheme
  when 'A' then normalize_a_map(MAP)
  when 'B' then normalize_b_map(MAP)
  else     raise NotImplementedError, "folding scheme #{f.inspect}"
  end
end

def folding_scheme
  MAP.lines[edge_len][0].match?(/[.#]/) ? 'A' : 'B'
end

def edge_len = @edge_len ||= Math.sqrt(MAP.scan(/\S/).count / 6).to_i

# just remove leading spaces
def normalize_a_map(map) = map.gsub(/^ +/, '')

# transmogrify to a-style
def normalize_b_map(map, s = edge_len)
  lines = map.lines.map(&:chomp)

  face_1 = lines[0...s].map { |l| l.chars[s...(s * 2)] }
  face_2 = lines[(s * 3)...(s * 4)].map { |l| l.chars[...s] }.tap { rot90(_1) }
  face_3 = lines[(s * 2)...(s * 3)].map { |l| l.chars[...s] }.tap { rot90(_1) }
  face_4 = lines[s...(s * 2)].map { |l| l.chars[s...(s * 2)] }
  face_5 = lines[(s * 2)...(s * 3)].map { |l| l.chars[s...(s * 2)] }
  face_6 = lines[0...s].map { |l| l.chars[(s * 2)...] }.tap { rot90(_1, 2) }

  face_row_1 = face_1.map(&:join)
  face_row_2 = face_2.map.with_index { |chrs, i| (chrs + face_3[i] + face_4[i]).join }
  face_row_3 = face_5.map.with_index { |chrs, i| (chrs + face_6[i]).join }

  [*face_row_1, *face_row_2, *face_row_3].join("\n")
end

def rot90(arr, n = 1) = n.times { arr.replace(arr.transpose.map(&:reverse)) }

def move(x:, y:, z:, dir:, face:, steps:)
  steps.times do
    current_position = [x, y, z, dir, face]
    face.put('o', x:, y:, z:) # mark trail
    x, y, z = [x, y, z].map.with_index { |c, i| c + dir[i] }

    if (dest = face.get(x:, y:, z:)).nil? # edge reached, wrap around
      x, y, z = [x, y, z].map { |v| v.clamp(0, edge_len - 1) }
      face, dir = face.adj(dir), face.perpendicular
      dest = face.get(x:, y:, z:) || fail
    end

    return current_position if dest == '#'
  end

  [x, y, z, dir, face]
end

# project 3d coords and direction back to original folding scheme. ugh.
def score(x:, y:, z:, face:, dir:)
  score_row, score_col, score_dir =
    case [folding_scheme, face.num]
    when ['A', 3] then [edge_len + z, edge_len * 2 - y - 1, dir]
    when ['B', 3] then [edge_len * 2 + y, z, face.turn_dir(dir, -1)]
    else raise NotImplementedError, "#{face} score in scheme #{folding_scheme}"
    end

  1000 * (score_row + 1) + 4 * (score_col + 1) + face.dirs.index(score_dir)
end

run
