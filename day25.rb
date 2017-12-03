input = <<-EOS
... paste input here ...
EOS

class State
  attr_accessor :name, :instruction_0, :instruction_1

  def initialize(string)
    /(?<name>\w):.*
     (?<val0>\d).*(?<dir0>right|left).*(?<next0>\w)\..*
     (?<val1>\d).*(?<dir1>right|left).*(?<next1>\w)\./xm =~ string
    self.name = name
    self.instruction_0 = Instruction.new(val0, dir0, next0)
    self.instruction_1 = Instruction.new(val1, dir1, next1)
  end
end

class Instruction
  attr_accessor :value, :direction, :next_state

  def initialize(value, direction, next_state)
    self.value = value.to_i
    self.direction = direction == 'left' ? -1 : 1
    self.next_state = next_state
  end
end

task, states_descriptions = input.split('steps.')
/(?<start_state>\w)\.\D*(?<steps>\d+)/ =~ task
states = states_descriptions.split('In state')[1..-1].map { |sd| State.new(sd) }

tape = Hash.new(0)
cursor = 0
current_state = states.find { |s| s.name == start_state }

steps.to_i.times do
  instruction = current_state.send("instruction_#{tape[cursor]}")
  tape[cursor] = instruction.value
  cursor += instruction.direction
  current_state = states.find { |s| s.name == instruction.next_state }
end

puts "checksum after #{steps} steps: #{tape.values.count(1)}"
