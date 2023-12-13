f = __FILE__.sub(/(day..).*/, '\1_input')

inputs = File.read(f).split("\n\n").map { _1.split("\n") }

def score(input, diff = 0)
  find_mirror_axis(input.dup, diff)&.*(100) ||
    find_mirror_axis(input.map(&:chars).transpose.map(&:reverse), diff)
end

def find_mirror_axis(lines, diff = 0, size = lines.size, mirror = [])
  (1...size).find do |i|
    mirror.unshift(lines.shift)
    a = lines[...i].join("\n")
    b = mirror[...(size - i)].join("\n")
    a.each_char.with_index.count { |chr, i| b[i] != chr } == diff
  end
end

# part 1
p inputs.sum { score(_1) }

# part 2
p inputs.sum { score(_1, 1) }
