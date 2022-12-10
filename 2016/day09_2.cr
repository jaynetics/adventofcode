f = __FILE__.sub(/day..\K.*/, "_input")

def decompressed_size(str : String) : Int64
  if m = /\((\d+)x(\d+)\)/.match(str)
    m.pre_match.size.to_i64 +
      decompressed_size(m.post_match[...(m[1].to_i)]) * m[2].to_i +
      decompressed_size(m.post_match[(m[1].to_i)..])
  else
    str.size.to_i64
  end
end

puts decompressed_size(File.read(f))
