f = __FILE__.sub(/\d\..*/, "input")

# this implements an optimization idea:
# compare only numbers with each other that can make 2020
lo = [] of Int32
hi = [] of Int32

File.each_line(f) do |line|
  num = line.to_i
  num < 1010 ? lo << num : hi << num # edge case: 1010
end

lo.find { |n1| hi.find { |n2| n1 + n2 == 2020 && p(n1 * n2) } }
