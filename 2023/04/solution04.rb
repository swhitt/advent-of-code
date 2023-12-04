require_relative "../../lib/base"

class AoC::Year2023::Solution04 < Base
  CARD_NUMBER_REGEX = /Card\s+(\d+)/

  def part1
    input_lines.sum { |card_str| points(card_str) }
  end

  def part2
    card_copies = Hash.new(0)
    parsed_cards = input_lines.map { |card_str| parse(card_str) }

    parsed_cards.each { |card_number, _, _| card_copies[card_number] = 1 }

    parsed_cards.each do |card_number, before_numbers, after_numbers|
      (before_numbers & after_numbers).size.times do |i|
        next_card_number = card_number + i + 1
        if card_copies.key?(next_card_number)
          card_copies[next_card_number] += card_copies[card_number]
        end
      end
    end

    card_copies.values.sum
  end

  def parse(card_str)
    number = card_str[CARD_NUMBER_REGEX, 1].to_i
    before, after = card_str.split(":").last.split("|").map(&:strip)

    [number, before.scan(/\d+/).map(&:to_i), after.scan(/\d+/).map(&:to_i)]
  end

  def points(card_str)
    _, before, after = parse(card_str)
    matches = before & after
    matches.empty? ? 0 : 2**(matches.size - 1)
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution04.new
  solution.run
end
