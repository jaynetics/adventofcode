# crystal build --release 2023/day05_2.cr && time ./day05_2

F = __FILE__.sub(/\d\..*/, "input")

alias SeedRange = Range(Int64, Int64)

SEEDS = [] of SeedRange

File.read_lines(F).first.scan(/\d+/).map(&.[0].to_i64).each_slice(2) do |(d1, d2)|
  SEEDS << (d1..(d1 + d2 - 1))
end

MAPS = {} of String => Tuple(String, Array(Tuple(SeedRange, SeedRange)))

File.read(F).scan(/(\w+)-to-(\w+) map:\n([^a-z]+)/i).each do |(_, a, b, instr)|
  MAPS[a] = {
    b,
    instr.chomp.lines.map do |line|
      nums = line.scan(/\d+/).map(&.[0].to_i64)
      {(nums[1])..(nums[1] + nums[2] - 1), (nums[0])..(nums[0] + nums[2] - 1)}
    end,
  }
end

def apply_maps(name : String, seeds : Array(SeedRange))
  dest, instr = MAPS[name]
  new_seeds = [] of SeedRange
  seeds_to_do = seeds.dup

  while seeds_to_do.any?
    seed = seeds_to_do.shift
    instr.any? do |(src, target)|
      beg_loss = [src.begin - seed.begin, 0].max
      end_loss = [seed.end - src.end, 0].max
      covered = ((seed.begin + beg_loss)..(seed.end - end_loss))
      next if covered.size < 1

      offset = target.begin - src.begin
      new_seeds << ((covered.begin + offset)..(covered.end + offset))
      seeds_to_do << ((seed.begin)..(covered.begin - 1)) if beg_loss > 0
      seeds_to_do << ((covered.end + 1)..(seed.end)) if end_loss > 0
      true
    end || new_seeds.push(seed) # default to no change
  end

  dest == "location" ? p(new_seeds.map(&.first).min) : apply_maps(dest, new_seeds)
end

apply_maps("seed", SEEDS)
