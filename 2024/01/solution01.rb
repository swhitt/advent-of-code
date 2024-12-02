require_relative "../../lib/base"

# Solution for the 2024 day 1 puzzle
# https://adventofcode.com/2024/day/1
class AoC::Year2024::Solution01 < Base
  def part1
    left, right = input_nums.transpose
    left.sort.zip(right.sort).sum { |a, b| (a - b).abs }
  end

  def part2
    left, right = input_nums.transpose
    (left & right).sum { |num| left.count(num) * right.count(num) * num }
  end
end
