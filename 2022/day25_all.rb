f = __FILE__.sub(/(day..)\K.*/, "_input")

MAP = { '0' => 0, '1' => 1, '2' => 2, '-' => -1, '=' => -2 }

def decode(str)
  str.chars.reverse_each.with_index.sum { |c, i| MAP[c] * 5 ** i }
end

def encode(int)
  keep = 0
  int.to_s(5).chars.reverse_each.with_object([]) do |pental, acc|
    case local_val = pental.to_i + keep
    when 0..2
      acc << local_val
      keep = 0
    when 3..5
      acc << local_val - 5
      keep = 1
    end || fail
  end.tap { _1 << keep if keep > 0 }.reverse.map { MAP.rassoc(_1)[0] }.join
end

puts File.readlines(f, chomp: true).sum { decode(_1) }.then { encode(_1) }
