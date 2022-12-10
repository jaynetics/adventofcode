f = __FILE__.sub(/(day..).*/, '\1_input')

x = 1
cycle = 1
pixels = []
width = 40

run_cycle = ->() do
  pixels << ((cycle % width).between?(x, x + 2) ? '█' : ' ')
  cycle += 1
end

File.foreach(f) { |line|
  run_cycle.()
  if line =~ /-?\d+/
    run_cycle.()
    x += $&.to_i
  end
}

puts pixels.each_slice(width).map(&:join)
