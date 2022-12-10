f = __FILE__.sub(/day..\K.*/, "_input")

str = File.read(f)
idx = 0
acc = ""

loop do
  chr = str[idx]? || break

  if chr == '('
    m = /^\((\d+)x(\d+)\)/.match(str[idx..]) || raise("no match")
    # note: $1 etc. exist, but pre/post match vars $` and $' do not
    acc += m.post_match[...m[1].to_i] * m[2].to_i
    idx += m[0].size + m[1].to_i
  else
    acc += chr
    idx += 1
  end
end

puts acc.size
