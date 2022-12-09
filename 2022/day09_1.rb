f = __FILE__.sub(/(day..).*/, '\1_input')

hx, hy, tx, ty = 0, 0, 0, 0
t_history = [[tx, ty]]

move = ->(x: 0, y: 0) do
  hx += x
  hy += y

  xdiff = hx - tx
  ydiff = hy - ty
  next if (-1..1).cover?(xdiff) && (-1..1).cover?(ydiff) # still adjacent

  tx += xdiff.clamp(-1, 1)
  ty += ydiff.clamp(-1, 1)
  t_history << [tx, ty]
end

File.foreach(f) do |line|
  case line
  when /R (\d+)/ then $1.to_i.times { move.(x: 1) }
  when /L (\d+)/ then $1.to_i.times { move.(x: -1) }
  when /U (\d+)/ then $1.to_i.times { move.(y: 1) }
  when /D (\d+)/ then $1.to_i.times { move.(y: -1) }
  end
end

p t_history.uniq.count
