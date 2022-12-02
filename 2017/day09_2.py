s = '''... paste input here ...'''

score = 0
group_level = 0
skip_one = False
ignore = False
ignored_count = 0

for char in s:
  if skip_one:
    skip_one = False
  elif char == '!':
    skip_one = True
  elif ignore:
    if char == '>':
      ignore = False
    else:
      ignored_count += 1
  elif char == '<':
    ignore = True
  elif char == '{':
    score += 1 + group_level
    group_level += 1
  elif char == '}':
    group_level -= 1

print ignored_count
