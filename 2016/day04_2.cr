f = __FILE__.sub(/\d\..*/, "input")

abc = ('a'..'z').to_a

File.each_line(f) { |line|
  # Unlike Ruby, named groups don't result in local vars
  m = /(?<name>.+)-(?<id>\d+)/.match(line) || raise(line)
  # In Ruby, this #tr could be done a little nicer with `gsub(/./, <hash>)`
  rot_name = m["name"].tr(abc.join, abc.rotate(m["id"].to_i).join)
  break puts(m["id"]) if rot_name.includes?("northpole")
}
