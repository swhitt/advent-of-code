require_relative "../../lib/base"

class AoC::Year2024::Solution01 < Base
  def part1
    left, right = number_columns
    left.sort.zip(right.sort).sum { |a, b| (a - b).abs }
  end

  def part2
    left, right = number_columns
    (left & right).sum { |num| left.count(num) * right.count(num) * num }
  end

  private

  def number_columns
    input_lines
      .map { _1.split.map(&:to_i) }
      .transpose
  end
end
