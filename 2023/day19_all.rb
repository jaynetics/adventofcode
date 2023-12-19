f = __FILE__.sub(/(day..).*/, '\1_input')

Rule = Struct.new(:letter, :operator, :number, :branches) do
  def self.parse(str)
    /(?<let>\w)(?<op>.)(?<num>\d+):(?<b1>\w+),(?<b2>.+)/ =~ str or return str
    new(let, op, num.to_i, [parse(b1), parse(b2)])
  end

  def check(rating)
    val = rating.fetch(letter)
    branch = val.send(operator, number) ? branches[0] : branches[1]
    branch.is_a?(Rule) ? branch.check(rating) : branch
  end
end

workflows = File.read(f).scan(/(\w+)\{(.+)\}/).to_h { [_1, Rule.parse(_2)] }

ratings = File.foreach(f).grep(/=/).map { |l| l.scan(/(\w)=(\d+)/).to_h { [_1, _2.to_i] } }

# part 1
state = ratings.to_h { [_1, 'in'] }
accepted = []

state.each do |rating, wfid|
  rule = workflows.fetch(wfid)
  case result = rule.check(rating)
  when 'A' then accepted.push(rating) && state.delete(rating)
  when 'R' then state.delete(rating)
  else state[rating] = result
  end
end until state.empty?

p accepted.sum { _1.values.sum }

# part 2
# some other options i considered:
# - trace tree structure, determine rule-sequences for each
#   letter, then find values that can pass these sequences
# - bisect each letter on each node
# - branch prediction, lol
# - dilettante math (but only the example result was a multiple of 4k)

inputs = %w[x m a s].to_h { [_1, 1..4000] }
wins = 0

Rule.define_method(:divide_et_impera) do |input|
  range = input.fetch(letter)
  split_ranges =
    if operator == '<' then [range.begin..number.pred, number..range.end]
    else                    [number.succ..range.end, range.begin..number]
    end

  split_ranges.zip(branches).each do |range, branch|
    branch_input = input.merge(letter => range)
    case branch
    when Rule then branch.divide_et_impera(branch_input)
    when 'A'  then wins += branch_input.values.map(&:size).reduce(:*)
    when 'R'  then next
    else           workflows.fetch(branch).divide_et_impera(branch_input)
    end
  end
end

workflows['in'].divide_et_impera(inputs)
p wins
