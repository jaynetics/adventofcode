f = __FILE__.sub(/\d+\..*/, "input")

Node = Struct.new(:name, :value) do
  def <<(child) = children << child

  def children = value.respond_to?(:each) ? value : nil

  def traverse(&block)
    block.call(self)
    children&.each { |c| c.traverse(&block) }
  end

  def size = children&.sum(&:size) || value
end

root = Node.new('/', [])

File.foreach(f).with_object([root]) do |line, pwd_stack|
  pwd = pwd_stack.last
  case line.chomp
  when '$ cd /'     then pwd_stack.replace([root])
  when '$ cd ..'    then pwd_stack.pop if pwd_stack.size > 1
  when /cd (.+)/    then pwd_stack << pwd.children.find { |c| c.name == $1 }
  when /dir (.+)/   then pwd << Node.new($1, [])
  when /(\d+) (.+)/ then pwd << Node.new($2, $1.to_i)
  end
end

# part 1

small_dirs = []
root.traverse { |n| small_dirs << n if n.children && n.size <= 100_000 }
puts small_dirs.sum(&:size)

# part 2

missing_space = root.size - 40_000_000
dirs = []
root.traverse { |n| dirs << n if n.children }
puts dirs.sort_by(&:size).find { |d| d.size >= missing_space }.size
