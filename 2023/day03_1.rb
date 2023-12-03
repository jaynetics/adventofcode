f = __FILE__.sub(/\d\..*/, 'input')

nums = {}
syms = {}

File.foreach(f).with_index do |line, y|
  line.gsub(/\d+/) { |num| nums[[$`.size, $`.size + num.size - 1, y]] = num }
  line.gsub(/[^\d\n.]/) { |sym| syms[[$`.size, y]] = sym }
end

p nums.select { |(x1, x2, y)|
  ((x1 - 1)..(x2 + 1)).to_a.product(((y - 1)..(y + 1)).to_a).any? { |x, y| syms[[x, y]] }
}.values.sum(&:to_i)
