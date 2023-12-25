require_relative "../../lib/base"

# Solution for the 2023 day 4 puzzle
# https://adventofcode.com/2023/day/4
class AoC::Year2023::Solution04 < Base
  CARD_NUMBER_REGEX = /Card\s+(\d+)/

  def part1
    input_lines.sum(&method(:card_points))
  end

  def card_points(card_str)
    _, before, after = parse_card(card_str)
    (before & after).then { _1.empty? ? 0 : 2**(_1.size - 1) }
  end

  def part2
    card_copies = Hash.new(0)
    parsed_cards = input_lines.map(&method(:parse_card))

    parsed_cards.each { |card_number, _, _| card_copies[card_number] = 1 }

    parsed_cards.each do |card_number, before_numbers, after_numbers|
      overlapping_card_count = (before_numbers & after_numbers).size
      overlapping_card_count.times do |i|
        next_card_number = card_number + i + 1
        if card_copies.key?(next_card_number)
          card_copies[next_card_number] += card_copies[card_number]
        end
      end
    end

    card_copies.values.sum
  end

  def parse_card(card_str)
    number = card_str[CARD_NUMBER_REGEX, 1].to_i
    before, after = card_str.split(":").last.split("|").map(&:strip)

    [number, before.scan(/\d+/).map(&:to_i), after.scan(/\d+/).map(&:to_i)]
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution04.new
  solution.run
end
