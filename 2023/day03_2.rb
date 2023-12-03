f = __FILE__.sub(/\d\..*/, 'input')

nums = {}
syms = {}

File.foreach(f).with_index do |line, y|
  line.gsub(/\d+/) { |num| nums[[$`.size, $`.size + num.size - 1, y]] = num }
  line.gsub(/[^\d\n.]/) { |sym| syms[[$`.size, y]] = sym }
end

p syms.select { |_, v| v == '*' }.sum { |(x, y), _|
  adj_xy = ((x - 1)..(x + 1)).to_a.product(((y - 1)..(y + 1)).to_a)
  adj_nums = nums.select { |(x1, x2, ny)| (x1..x2).any? { adj_xy.include?([_1, ny]) } }
  adj_nums.count == 2 ? adj_nums.values.map(&:to_i).reduce(:*) : 0
}
