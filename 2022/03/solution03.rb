require_relative "../../lib/base"

class AoC::Year2022::Solution03 < Base
  def part1
    input_lines.sum { |line| find_common_item_score(line) }
  end

  def part2
    input_lines.each_slice(3).sum { |group| find_common_badge_score(group) }
  end

  private

  def find_common_item_score(rucksack)
    midpoint = rucksack.size / 2
    first_half = rucksack[0...midpoint].chars
    second_half = rucksack[midpoint..].chars

    common_chars = first_half & second_half
    score_for_char(common_chars.first)
  end

  def find_common_badge_score(group)
    common_chars = group.map(&:chars).reduce(&:&)
    score_for_char(common_chars.first)
  end

  def score_for_char(char)
    return unless char

    ord_value = char.ord
    if ord_value >= "a".ord
      ord_value - "a".ord + 1
    else
      ord_value - "A".ord + 27
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2022::Solution03.new
  solution.run
end
