f = __FILE__.sub(/(day..).*/, '\1_input')

HANDS = File.read(f).scan(/(.+) (.+)/).to_h { [_1, _2.to_i] }

TYPES = [
  /(.)\1{4}/,                            # five of a kind
  /(.)(?:.*\1){3}/,                      # four of a kind
  /(?=.*(.)(?:.*\1){2}).*(.).*(?!\1)\2/, # full house
  /(.)(?:.*\1){2}/,                      # three of a kind
  /(?=.*(.).*\1).*(.).*(?!\1)\2/,        # two pairs
  /(.).*\1/,                             # one pair
  /./,                                   # high card
]

def score(hands_with_types, values:)
  hands_with_types.sort do |(h1, t1), (h2, t2)|
    diff_idx = (0..4).find { |i| h1[i] != h2[i] } || 0
    [t1, values.index(h1[diff_idx])] <=> [t2, values.index(h2[diff_idx])]
  end.reverse_each.with_index(1).sum { |(hand), i| HANDS[hand] * i }
end

# part 1
hands_with_types = HANDS.map { |h,| [h, TYPES.find_index { _1.match?(h) }] }

p score(hands_with_types, values: %w[A K Q J T 9 8 7 6 5 4 3 2])

# part 2
hands_with_joker_types = hands_with_types.to_h do |hand, type|
  (hand.chars.uniq - %w[J]).repeated_combination(hand.count('J')) do |combo|
    alt_hand = combo.inject(hand) { |str, chr| str.sub('J', chr) }
    type = [type, TYPES.find_index { _1.match?(alt_hand) }].min
    break if type == 0 # minor optimization: stop if already ideal
  end

  [hand, type]
end

p score(hands_with_joker_types, values: %w[A K Q T 9 8 7 6 5 4 3 2 J])
