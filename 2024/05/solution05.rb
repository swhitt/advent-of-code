require_relative "../../lib/base"

# Solution for the 2024 day 5 puzzle
# https://adventofcode.com/2024/day/5
class AoC::Year2024::Solution05 < Base
  def part1
    rules, sequences = parse_input(input)
    sequences.select { |seq| valid_sequence?(seq, rules) }
      .sum { _1[_1.length / 2] }
  end

  def part2
    rules, sequences = parse_input(input)
    sequences.reject { |seq| valid_sequence?(seq, rules) }
      .map! { sort_sequence(_1, rules) }
      .sum { _1[_1.length / 2] }
  end

  private

  def parse_input(input)
    rules_text, sequences_text = input.split("\n\n")
    rules = Hash.new { |h, k| h[k] = Set.new }

    rules_text.each_line do |line|
      before, after = line.strip.split("|").map(&:to_i)
      rules[before] << after
    end

    sequences = sequences_text.lines.map { _1.strip.split(",").map(&:to_i) }
    [rules, sequences]
  end

  def valid_sequence?(sequence, rules)
    sequence.each_index.none? do |i|
      sequence[i + 1..].any? { |num2| rules[num2].include?(sequence[i]) }
    end
  end

  def sort_sequence(sequence, rules)
    sequence.sort do |a, b|
      if rules[a].include?(b)
        1
      elsif rules[b].include?(a)
        -1
      else
        0
      end
    end
  end
end
