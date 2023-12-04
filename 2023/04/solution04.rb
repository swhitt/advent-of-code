require_relative "../../lib/base"

class AoC::Year2023::Solution04 < Base
  def part1
    input_lines.sum do |card_string|
      _, before_numbers, after_numbers = parse_card_string(card_string)
      matches = before_numbers & after_numbers
      matches.empty? ? 0 : 2**(matches.size - 1)
    end
  end

  def part2
    card_copies = Hash.new(0)
    parsed_cards = input_lines.map { |line| parse_card_string(line) }

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

  def parse_card_string(card_string)
    card_number = card_string[/Card\s+(\d+):/, 1].to_i
    before_pipe, after_pipe = card_string.split(":").last.split("|").map(&:strip)

    before_numbers = before_pipe.scan(/\d+/).map(&:to_i)
    after_numbers = after_pipe.scan(/\d+/).map(&:to_i)

    [card_number, before_numbers, after_numbers]
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution04.new
  solution.run
end
