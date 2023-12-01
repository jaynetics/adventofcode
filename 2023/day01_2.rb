f = __FILE__.sub(/\d\..*/, 'input')

nums = {
  'one' => '1', 'two' => '2', 'three' => '3', 'four' => '4', 'five' => '5',
  'six' => '6', 'seven' => '7', 'eight' => '8', 'nine' => '9'
}
rev_nums = nums.transform_keys(&:reverse)

p File.foreach(f).sum { |line|
  first = line.gsub(Regexp.union(nums.keys), nums)[/\d/]
  last = line.reverse.gsub(Regexp.union(rev_nums.keys), rev_nums)[/\d/]
  (first + last).to_i
}
