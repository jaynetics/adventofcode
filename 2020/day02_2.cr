f = __FILE__.sub(/\d\..*/, "input")

count = 0

File.each_line(f) do |line|
  next unless m = /(?<p1>\d+)-(?<p2>\d+) (?<chr>\S): (?<pw>\S+)/.match(line)

  # String#[n] returns a Char in crystal
  # - as a result, `str[n] == other_str` is simply always false.
  # - `str[n..n]` returns a String instead (hmm...), and as a result,
  #   `str[n..n] == other_str` works. It looks weird, though.
  # - `str[n] == other_str.chars.first` is cumbersome, but maybe the most clear?

  chr = m["chr"].chars.first # => instance of Char
  idx1 = m["p1"].to_i - 1
  idx2 = m["p2"].to_i - 1
  pw = m["pw"]

  count += 1 if (pw[idx1]? == chr) ^ (pw[idx2]? == chr)
end

p count
