f = __FILE__.sub(/\d\..*/, "input")

# Note how we need to use the null-safe #[]?,
# even if we don't do anything with the return value :/
p File.read_lines(f).count { |l| l[/(.)(?!\1)(.)\2\1/]? && !l[/\[\w*(.)(?!\1)(.)\2\1/]? }
