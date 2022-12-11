f = __FILE__.sub(/(day..).*/, '\1_input')

Actor = Struct.new(:stack, :op, :move, :div, :counter, keyword_init: true) do
  def self.from_description(desc)
    stack = desc[/items: \K.+/].split(',').map(&:to_i)

    op_str = desc[/new = \K.+/]
    op = ->(old) { eval(op_str) }

    div, idx_a, idx_b = desc[/divisible by \K.+/m].scan(/\d+/).map(&:to_i)
    move = ->(val) {
      shared_divisible = val % $actors.map(&:div).reduce(:*)
      $actors[val % div == 0 ? idx_a : idx_b].stack << shared_divisible
    }

    new(stack:, op:, move:, div:, counter: 0)
  end

  def act(divisor: 3)
    stack.reject! do |val|
      new_val = op.call(val) / divisor
      move.call(new_val)
      self.counter += 1
    end
  end
end

# part 1
$actors = File.read(f).split("\n\n").map { Actor.from_description(_1) }

20.times { $actors.each(&:act) }

p $actors.map(&:counter).max(2).reduce(:*)

# part 2
$actors = File.read(f).split("\n\n").map { Actor.from_description(_1) }

10_000.times { $actors.each { |a| a.act(divisor: 1) } }

p $actors.map(&:counter).max(2).reduce(:*)
