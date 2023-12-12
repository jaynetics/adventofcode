f = __FILE__.sub(/(day..).*/, '\1_input')

datasets = File.read(f).scan(/(.+) (.+)/).map { [_1, _2.split(',').map(&:to_i)] }

def permutations(str, nums, lvl = 0, offset = 0, num = nums[0], rem = nums.sum - num, memo = {})
  memo[[lvl, offset]] ||= begin
    count = 0

    str.scan(/(?<!#|X)(?=[#?]{#{num}}(?!#|.*X))/) do
      offset = $`.size
      new_str = str.dup.tap { _1[offset, num] = 'X' * num }
      next if $`.include?('#') || new_str.count('#') > rem
      next count += 1 unless next_num = nums[lvl + 1]

      count += permutations(new_str, nums, lvl + 1, offset, next_num, rem - next_num, memo)
    end

    count
  end
end

# part 1
p datasets.sum { permutations(_1, _2) }

# part 2
p datasets.sum { permutations(([_1] * 5).join('?'), _2 * 5) }
