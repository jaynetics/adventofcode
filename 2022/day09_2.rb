f = __FILE__.sub(/(day..).*/, '\1_input')

items = Array.new(10) { [0, 0] }
histories = items.map.with_index { |pos, idx| [idx, pos.dup] }.to_h

move = ->(x: 0, y: 0, depth: 0) do
  item = items[depth]
  item[0] += x
  item[1] += y
  histories[depth] << item.dup
  next unless succ = items[depth + 1]

  xdiff = item[0] - succ[0]
  ydiff = item[1] - succ[1]
  next if (-1..1).cover?(xdiff) && (-1..1).cover?(ydiff) # still adjacent

  move.(x: xdiff.clamp(-1, 1), y: ydiff.clamp(-1, 1), depth: depth + 1)
end

File.foreach(f) do |line|
  case line
  when /R (\d+)/ then $1.to_i.times { move.(x: 1) }
  when /L (\d+)/ then $1.to_i.times { move.(x: -1) }
  when /U (\d+)/ then $1.to_i.times { move.(y: 1) }
  when /D (\d+)/ then $1.to_i.times { move.(y: -1) }
  end
end

p histories[9].uniq.count
