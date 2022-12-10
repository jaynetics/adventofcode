f = __FILE__.sub(/\d\..*/, "input")

p File.read_lines(f).count { |line|
  line.scan(/(?=(\w)((?!\1)\w)\1)(?![^\[]*\])/) do
    # Note: there is no short interpolation such as `/#$1/`
    break 1 if line =~ /\[\w*#{$2}#{$1}#{$2}/
  end == 1
}
