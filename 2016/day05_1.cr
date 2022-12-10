f = __FILE__.sub(/\d\..*/, "input")

require "digest"

input = File.read(f).chomp
acc = [] of Char

(0..).each do |n|
  md5 = Digest::MD5.hexdigest("#{input}#{n}")
  acc << md5[5] if md5.starts_with?("00000")
  break p(acc.join) if acc.size == 8
end
