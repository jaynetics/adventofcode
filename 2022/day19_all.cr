f = __FILE__.sub(/(day..)\K.*/, "_input")

alias Blueprint = Tuple(Int8, Int8, Int8, Int8, Int8, Int8, Int8)

blueprints = File.read(f).scan(/:[^B]+/).map do |(match)|
  c1, c2, c3, c4, c5, c6 = match.scan(/\d+/).map { |(d)| d.to_i8 }
  max_ore_cost = [c1, c2, c3, c5].max
  Blueprint.new(c1, c2, c3, c4, c5, c6, max_ore_cost)
end

def run(
  bp : Blueprint,
  n = 24,
  kill : Int32 | Nil = nil,                   # optimization for part 2
  b_ore = 0, b_cla = 0, b_obs = 0, b_geo = 0, # budgets
  w_ore = 1, w_cla = 0, w_obs = 0, w_geo = 0, # workers
  n_ore = 0, n_cla = 0, n_obs = 0, n_geo = 0, # new workers
  &blk : Int32 -> Void
)
  b_ore += w_ore
  b_cla += w_cla
  b_obs += w_obs
  b_geo += w_geo

  w_ore += n_ore
  w_cla += n_cla
  w_obs += n_obs
  w_geo += n_geo

  n -= 1

  return yield(b_geo) if n == 0

  # optimization: skip last round if no new geo worker just came online
  return yield(b_geo + w_geo) if n == 1 && n_geo == 0

  # optimization for part 2: kill branches early that can't surpass previously known best.
  #
  # further optimization idea:
  # calculate best results for 1...n individually and always kill branches
  return if n == 7 && kill && kill > b_geo

  # geode worker - if building it is possible, assume this is ideal and try nothing else
  r_ore = b_ore - bp[4]
  r_obs = b_obs - bp[5]
  if r_ore >= 0 && r_obs >= 0
    run(bp, n, kill, r_ore, b_cla, r_obs, b_geo, w_ore, w_cla, w_obs, w_geo, 0, 0, 0, 1, &blk)
    return
  end

  # else, always evaluate do-nothing option (saving for specific worker might be ideal).
  # further possible optimization: avoid stupid waiting, i.e. don't build any worker later
  # that coud be afforded now.
  run(bp, n, kill, b_ore, b_cla, b_obs, b_geo, w_ore, w_cla, w_obs, w_geo, 0, 0, 0, 0, &blk)

  # no robot costs less than 2 ore
  return if b_ore < 2

  # possible optimization: sort blueprint by ascending ore cost, as all workers
  # need ore, and break when cheapest worker can't be paid.
  # array-traversing sorted blueprints is probably more expensive than int checks ...
  # unless we generate the code with a macro :>

  # ore worker - only try building it if more ore can be spent
  if w_ore < bp[6]
    r_ore = b_ore - bp[0]
    if r_ore >= 0
      run(bp, n, kill, r_ore, b_cla, b_obs, b_geo, w_ore, w_cla, w_obs, w_geo, 1, 0, 0, 0, &blk)
    end
  end

  # clay worker
  r_ore = b_ore - bp[1]
  if r_ore >= 0
    run(bp, n, kill, r_ore, b_cla, b_obs, b_geo, w_ore, w_cla, w_obs, w_geo, 0, 1, 0, 0, &blk)
  end

  # obsidian worker
  r_ore = b_ore - bp[2]
  r_cla = b_cla - bp[3]
  if r_ore >= 0 && r_cla >= 0
    run(bp, n, kill, r_ore, r_cla, b_obs, b_geo, w_ore, w_cla, w_obs, w_geo, 0, 0, 1, 0, &blk)
  end
end

# part 1 (with data collection for part 2)
best_results = {} of Int32 => Int32

blueprints.each_with_index(1) { |bp, i|
  best = 0
  run(bp) { |res| best = res if res > best }
  puts "#{i}: #{best}"
  best_results[i] = best
}

puts best_results.map { |k, v| k * v }.sum

# part 2
puts blueprints.first(3).map_with_index(1) { |bp, i|
  best = 0
  run(bp, 32, best_results[i]) { |res| best = res if res > best }
  puts "#{i}: #{best}"
  best
}.product
