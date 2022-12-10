f = __FILE__.sub(/\d\..*/, "input")

x = 0
y = 0
direction = 0 # up

# Note: #scan has a different block signature compared to Ruby
File.read(f).scan(/(\w)(\d+)/).each do |(_match, turn, steps)|
  direction = (direction + (turn == "R" ? 1 : -1)) % 4

  case direction
  when 0 then y += steps.to_i # up
  when 1 then x += steps.to_i # right
  when 2 then y -= steps.to_i # down
  when 3 then x -= steps.to_i # left
  end
end

p x.abs + y.abs
