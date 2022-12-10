f = __FILE__.sub(/\d\..*/, "input")

require "digest"

input = File.read(f).chomp
acc = {} of Char => Char

(0..).each do |n|
  md5 = Digest::MD5.hexdigest("#{input}#{n}")
  acc[md5[5]] ||= md5[6] if md5 =~ /^00000[0-7]/
  break p(acc.to_a.sort.map(&.last).join) if acc.size == 8
end
