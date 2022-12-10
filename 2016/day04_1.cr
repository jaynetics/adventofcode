f = __FILE__.sub(/\d\..*/, "input")

p File.read(f).lines.sum { |line|
  m = /(?<name>.+)-(?<id>\d+)\[(?<checksum>.+)\]/.match(line) || raise(line)
  name = m["name"]
  # Note how the argument for sort_by with multiple fields must be a Tuple.
  # With an Array, the type of the elements would be ambiguous, causing
  # `Error: no overload matches 'Char#<=>' with type (Char | Int32)`.
  # The other option would be to make all comparanda the same type:
  # `[-name.count(c), c.ord]`
  ranked_chars = name.delete('-').chars.uniq.sort_by { |c| {-name.count(c), c} }
  ranked_chars.first(5).join == m["checksum"] ? m["id"].to_i : 0
}
