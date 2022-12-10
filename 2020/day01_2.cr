f = __FILE__.sub(/\d\..*/, "input")

nums = File.read(f).lines.map(&:to_i)

# optimization idea:
# remove numbers that can't make 2020 with two others
min = nums.min
nums.reject! { |n| n + (min * 2) > 2019 }

nums.find do |n1|
  nums.find do |n2|
    nums.find do |n3|
      n1 + n2 + n3 == 2020 && p(n1 * n2 * n3)
    end
  end
end
