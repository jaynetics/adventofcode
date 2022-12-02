f = __FILE__.sub(/\d\..*/, 'input')

# codegolf version
p eval"[#{File.read(f).tr(?\n,?+).gsub'++',?,}].max"

# streaming version
max = 0
group_sum = 0
File.foreach(f) do |line|
  if line == "\n"
    max = group_sum if group_sum > max
    group_sum = 0
  else
    group_sum += line.to_i
  end
end
p max
