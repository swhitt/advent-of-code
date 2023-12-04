require_relative "../../lib/base"

class AoC::Year2022::Solution04 < Base
  def part1
    parse_input.count do |range1, range2|
      range_contains?(range1, range2) || range_contains?(range2, range1)
    end
  end

  def part2
    parse_input.count { |range1, range2| ranges_overlap?(range1, range2) }
  end

  private

  def parse_input
    input_lines.map do |line|
      line.split(",").map { |range| range.split("-").map(&:to_i) }
    end
  end

  def range_contains?(range1, range2)
    range1_start, range1_end = range1
    range2_start, range2_end = range2
    (range1_start..range1_end).cover?(range2_start) && (range1_start..range1_end).cover?(range2_end)
  end

  def ranges_overlap?(range1, range2)
    range1_start, range1_end = range1
    range2_start, range2_end = range2
    range1_start <= range2_end && range1_end >= range2_start
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2022::Solution04.new
  solution.run
end
