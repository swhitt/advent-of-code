require_relative "../../lib/base"

CARD_STRENGTH = %w[2 3 4 5 6 7 8 8 9 T J Q K A].map.with_index(2) { [_1, _2] }.to_h

HAND_STRENGTH = {
  high_card: 1,
  one_pair: 2,
  two_pair: 3,
  three_of_a_kind: 4,
  full_house: 5,
  four_of_a_kind: 6,
  five_of_a_kind: 7
}

class AoC::Year2023::Solution07 < Base
  def part1
    calculate_total_winnings
  end

  def part2
    calculate_total_winnings(joker_wild: true)
  end

  def calculate_total_winnings(joker_wild: false)
    hands.sort { |(hand1, _bid1), (hand2, _bid2)| compare(hand1, hand2, joker_wild:) }
      .map.with_index(1) { |(_hand, bid), index| bid * index }.sum
  end

  def hands
    input_lines.map(&:split).map { |hand, bid| [hand.chars, bid.to_i] }
  end

  def compare(hand1, hand2, joker_wild: false)
    hand1 = hand1.chars if hand1.is_a?(String)
    hand2 = hand2.chars if hand2.is_a?(String)

    rank1 = HAND_STRENGTH[classify_hand(hand1, joker_wild:)]
    rank2 = HAND_STRENGTH[classify_hand(hand2, joker_wild:)]

    return rank1 <=> rank2 unless rank1 == rank2

    card_strengths = joker_wild ? CARD_STRENGTH.merge("J" => 1) : CARD_STRENGTH
    hand1_strengths = hand1.map { card_strengths[_1] }
    hand2_strengths = hand2.map { card_strengths[_1] }

    # NOTE: weird rules! to break ties, we go left to right and compare card strengths.
    hand1_strengths.zip(hand2_strengths).each do |strength1, strength2|
      comparison_result = strength1 <=> strength2
      return comparison_result unless comparison_result == 0
    end

    0
  end

  def classify_hand(hand, joker_wild: false)
    hand = hand.chars if hand.is_a?(String)
    return find_best_joker_hand(hand)[1] if joker_wild && hand.include?("J")
    counts = hand.tally.values.sort.reverse

    case counts
    when [5]
      :five_of_a_kind
    when [4, 1]
      :four_of_a_kind
    when [3, 2]
      :full_house
    when [3, 1, 1]
      :three_of_a_kind
    when [2, 2, 1]
      :two_pair
    when [2, 1, 1, 1]
      :one_pair
    else
      :high_card
    end
  end

  def find_best_joker_hand(hand)
    (CARD_STRENGTH.keys - ["J"]).map do |replacement_card|
      test_hand = hand.map { |card| (card == "J") ? replacement_card : card }
      [test_hand, classify_hand(test_hand, joker_wild: false)]
    end.max_by { HAND_STRENGTH[_1[1]] }
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution07.new
  solution.run
end
