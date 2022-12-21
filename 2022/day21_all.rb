f = __FILE__.sub(/(day..)\K.*/, "_input")

# part 1
input = File.read(f)
input.scan(/(.+):(.+)/).each { |id, body| eval "def #{id} = #{body}" }
puts root

# part 2 - bisect-search the correct value
eval "def difference = #{input[/root:\K.+/].tr(?+, ?-)}"

humn_val = 0
define_method(:humn) { humn_val }

loop do
  initial_diff = difference
  break if initial_diff == 0 # correct value has been found

  humn_val += 1 while (effect = (initial_diff - difference)).zero?
  humn_val += difference / effect
end

puts humn_val
