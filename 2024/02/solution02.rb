require_relative "../../lib/base"

# Solution for the 2024 day 2 puzzle
# https://adventofcode.com/2024/day/2
class AoC::Year2024::Solution02 < Base
  def part1
    input_nums.count { safe_report?(_1) }
  end

  def part2
    input_nums.count { safe_with_problem_dampener?(_1) }
  end

  def safe_report?(report)
    diffs = report.each_cons(2).map { |a, b| b - a }
    diffs.all? { |d| d.abs <= 3 } && (diffs.all?(&:positive?) || diffs.all?(&:negative?))
  end

  def safe_with_problem_dampener?(report)
    return true if safe_report?(report)

    report.each_index.any? do |i|
      safe_report?(report[0...i] + report[i + 1..])
    end
  end
end
