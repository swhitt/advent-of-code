require_relative "../../lib/base"

# Solution for the 2024 day 25 puzzle
# https://adventofcode.com/2024/day/25

class AoC::Year2024::Solution25 < Base
  def part1
    patterns = input.split("\n\n").map do |pattern|
      pattern.lines.flat_map.with_index do |line, i|
        line.chars.filter_map.with_index do |char, j|
          [i, j] if char == "#"
        end
      end.to_set
    end

    patterns.combination(2).count { |p1, p2| p1.disjoint?(p2) }
  end

  def part2
    "Keep the change ya filthy animal 🎄"
  end
end
