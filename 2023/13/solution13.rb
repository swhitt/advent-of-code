require_relative "../../lib/base"

# Solution for the 2023 day 13 puzzle
# https://adventofcode.com/2023/day/13
class AoC::Year2023::Solution13 < Base
  def part1
    pattern_blocks.sum { pattern_summary(_1) || 0 }
  end

  def part2
    # if we switch 1 character that equals 2 non-matches (both sides of the reflection)
    pattern_blocks.sum { pattern_summary(_1, non_matches: 2) || 0 }
  end

  def pattern_blocks
    @pattern_blocks ||= input.split("\n\n")
  end

  def pattern_summary(pattern, non_matches: 0)
    pattern = pattern.split("\n").map(&:chars)
    row = find_reflection(pattern, non_matches)
    return 100 * (row + 1) unless row.nil?

    transposed_pattern = pattern.first.zip(*pattern[1..])
    col = find_reflection(transposed_pattern, non_matches)
    (col + 1) unless col.nil?
  end

  def find_reflection(pattern, non_matches)
    pattern = pattern.map(&:join)
    (0...pattern.length - 1).each do |i|
      return i if count_non_matching_places(pattern, i) == non_matches
    end
    nil
  end

  def count_non_matching_places(pattern, index)
    pattern.each_with_index.inject(0) do |non_matching_places, (char, j)|
      comparison_index = index + 1 + (index - j)
      if comparison_index.between?(0, pattern.length - 1)
        non_matching_places + count_char_differences(pattern[j], pattern[comparison_index])
      else
        non_matching_places
      end
    end
  end

  def count_char_differences(string1, string2)
    string1.chars.zip(string2.chars).count { |char1, char2| char1 != char2 }
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution13.new
  solution.run
end
