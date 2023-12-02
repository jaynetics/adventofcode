f = __FILE__.sub(/\d\..*/, 'input')

games = File.read(f).scan(/(\d+): (.+)/).to_h do |id, sets|
  [id.to_i, sets.split(';').map { |set| set.scan(/(\d+) (\w+)/).to_h { [_2, _1] } }]
end

p games.sum { |_, sets|
  %w[red green blue].map { |cube| sets.map { _1[cube].to_i }.max }.reduce(:*)
}
