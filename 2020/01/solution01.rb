require_relative "../../lib/base"

class AoC::Year2020::Solution01 < Base
  def part1
    input_lines.map(&:to_i).combination(2).find { |a, b| a + b == 2020 }.reduce(:*)
  end

  def part2
    input_lines.map(&:to_i).combination(3).find { |a, b, c| a + b + c == 2020 }.reduce(:*)
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2020::Solution01.new
  solution.run
end
