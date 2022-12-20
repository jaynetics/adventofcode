# crystal build --release 2022/day20_all.cr && time ./day20_all

f = __FILE__.sub(/(day..)\K.*/, "_input")

nums = File.read(f).scan(/-?\d+/).map { |(d)| d.to_i64 }

def mix(arr : Array(Int64), n : Int32 = 1) : Array(Int64)
  # make numbers unique objects to allow addressing identical ones individually
  objects = arr.map_with_index { |num, idx| {num, idx} }
  len = arr.size

  n.times do
    arr.each_with_index do |num, orig_idx|
      obj = {num, orig_idx}
      cur_idx = objects.index(obj).not_nil!.to_i64
      new_idx = (cur_idx + num) % (len - 1)
      next if new_idx == cur_idx

      objects.delete(obj)
      if new_idx == 0 && num < 0 || new_idx > len - 2
        objects << obj
      else
        objects.insert(new_idx, obj)
      end
    end
  end

  objects.map(&.first)
end

# part 1
result = mix(nums)
z_idx = result.index(0) || raise("no zero?")
puts [1000, 2000, 3000].sum { |n| result[(z_idx + n) % result.size] }

# part 2
result = mix(nums.map(&.*(811589153)), 10)
z_idx = result.index(0) || raise("no zero?")
puts [1000, 2000, 3000].sum { |n| result[(z_idx + n) % result.size] }
