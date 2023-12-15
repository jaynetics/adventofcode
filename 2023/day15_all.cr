# crystal build --release 2023/day15_all.cr && time ./day15_all

F = __FILE__.sub(/(day..)\K.*/, "_input")

INPUTS = File.read(F).chomp.split(',')

def calc(input : String, cv : Int32 = 0)
  input.each_char { |c| cv += c.ord; cv *= 17; cv %= 256 }
  cv
end

# part 1
p INPUTS.sum { |input| calc(input) }

# part 2
BOXES = (0..255).to_h { |n| {n, [] of String} }

INPUTS.each do |input|
  box = BOXES[calc(input[/\w+/])]
  if input['-']?
    box.reject! { |el| el[/\w+/] == input[/\w+/] }
  elsif existing_idx = box.index { |el| el[/\w+/] == input[/\w+/] }
    box[existing_idx] = input
  else
    box << input
  end
end

p BOXES.sum { |n, box|
  box.each_with_index(1).sum { |(el, i)| (n + 1) * i * el[/\d+/].to_i }
}
