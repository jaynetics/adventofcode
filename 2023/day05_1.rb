f = __FILE__.sub(/\d\..*/, 'input')

SEEDS = File.foreach(f).first.scan(/\d+/).map(&:to_i)
MAPS = File.read(f).scan(/(\w+)-to-(\w+) map:\n([^a-z]+)/i).to_h do |a, b, instr|
  [a, [b, instr.chomp.lines.map { _1.scan(/\d+/).map(&:to_i) }]]
end

def apply_maps(name, seeds)
  dest, instr = MAPS.fetch(name)
  seeds.map! do |seed|
    seed_instr = instr.find { |_, src, n| seed.between?(src, src - 1 + n) }
    seed_instr ? seed_instr[0] + seed - seed_instr[1] : seed
  end
  dest == 'location' ? p(seeds.min) : apply_maps(dest, seeds)
end

apply_maps('seed', SEEDS)
