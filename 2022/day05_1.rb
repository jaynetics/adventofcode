f = __FILE__.sub(/\d\..*/, "input")

puts File.foreach(f).with_object({}) { |line, stacks|
  if line.include?('[')
    line.each_char.with_index { |c, i| c[/\w/] && (stacks[i / 4 + 1] ||= []).unshift(c) }
  elsif /move (?<count>\d+).+(?<from>\d+).+(?<to>\d+)/ =~ line
    count.to_i.times { stacks[to.to_i] << stacks[from.to_i].pop }
  end
}.sort.map { |_stack_id, stack| stack.last }.compact.join
