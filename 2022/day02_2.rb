f = __FILE__.sub(/\d\..*/, 'input')

p(File.foreach(f).map do |l|
  enemy_move_idx = 'ABC'.index(l[0])
  case l
  when /X/ # lose
    (enemy_move_idx + 2).remainder(3) + 1 + 0
  when /Y/ # draw
    enemy_move_idx                    + 1 + 3
  else     # win
    (enemy_move_idx + 1).remainder(3) + 1 + 6
  end
end.sum)
