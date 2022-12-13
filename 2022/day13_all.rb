f = __FILE__.sub(/(day..).*/, '\1_input')

pairs = File.read(f).split("\n\n").map { |g| eval "[#{g.tr(?\n, ?,)}]" }
indices = []

def debug(...)
  puts(...) if ENV['VERBOSE'].to_i == 1
end

def compare(l, r, depth = 1)
  debug("#{'  ' * depth}- Compare #{l} vs #{r}")

  if l.is_a?(Integer)
    res = r <=> l || fail
    res == 1 and debug("#{'  ' * (depth + 1)}- Left side is smaller", '')
    res == -1 and debug("#{'  ' * (depth + 1)}- Right side is smaller", '')
    return res
  end

  l.each.with_index do |l_el, i|
    r_el = r[i]
    res =
      if r_el.nil?
        debug("#{'  ' * (depth + 1)}- Right side ran out of items", '')
        -1
      elsif l_el == []
        debug("#{'  ' * (depth + 1)}- Left side ran out of items", '')
        1
      elsif l_el.is_a?(Array)
        compare(l_el, Array(r_el), depth + 1)
      elsif r_el.is_a?(Array)
        compare(Array(l_el), r_el, depth + 1)
      else
        compare(l_el, r_el, depth + 1)
      end
    return res unless res == 0
  end

  debug("#{'  ' * (depth + 1)}- Left side ran out of items", '')
  1
end

# part 1
pairs.each.with_index(1) do |(l, r), i|
  debug("== Pair #{i} ==")
  indices << i if compare(l, r) != -1
end

p indices.sum

# part 2
div_1 = [[2]]
div_2 = [[6]]
lines = pairs.flatten(1) + [div_1, div_2]
lines.sort! { |a, b| compare(b, a) }
debug(lines.map(&:to_s))

p (lines.index(div_1) + 1) * (lines.index(div_2) + 1)
