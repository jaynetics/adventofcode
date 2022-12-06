f = __FILE__.sub(/\d\..*/, "input")

str = File.read(f)
len = 14
p (0...str.size).find { |idx| str[idx, len] !~ /.*(.).*\1/ } + len
