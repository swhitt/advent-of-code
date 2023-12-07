require_relative "../../lib/base"

class AoC::Year2021::Solution01 < Base
  def part1
    input_lines
      .map(&:to_i)
      .each_cons(2)
      .count { |a, b| b > a }
  end

  def part2
    input_lines
      .map(&:to_i)
      .each_cons(3)
      .map(&:sum)
      .each_cons(2)
      .count { |a, b| b > a }
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2021::Solution01.new
  solution.run
end
