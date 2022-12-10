f = __FILE__.sub(/(day..).*/, '\1_input')

x = 1
cycle = 1
history = {}
run_cycle = ->() { (history[cycle] = x) && cycle += 1 }

File.foreach(f) { |line|
  run_cycle.()
  if line =~ /-?\d+/
    run_cycle.()
    x += $&.to_i
  end
}

p [20, 60, 100, 140, 180, 220].map { |c| history[c] * c }.sum
