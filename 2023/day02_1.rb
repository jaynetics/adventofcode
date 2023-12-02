f = __FILE__.sub(/\d\..*/, 'input')

games = File.read(f).scan(/(\d+): (.+)/).to_h do |id, sets|
  [id.to_i, sets.split(';').map { |set| set.scan(/(\d+) (\w+)/).to_h { [_2, _1] } }]
end

cubes = { 'red' => 12, 'green' => 13, 'blue' => 14 }

p games.reject { |_, sets|
  sets.any? { |set| cubes.any? { |cube, max| set[cube].to_i > max } }
}.keys.sum
