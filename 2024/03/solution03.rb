require_relative "../../lib/base"

# Solution for the 2024 day 3 puzzle
# https://adventofcode.com/2024/day/3
class AoC::Year2024::Solution03 < Base
  def part1
    input.scan(/mul\((\d+),(\d+)\)/).sum { |x, y| x.to_i * y.to_i }
  end

  def part2
    enabled = true
    input.scan(/mul\(\d+,\d+\)|do\(\)|don't\(\)/).sum do |cmd|
      case cmd
      when "do()" then enabled = true
                       0
      when "don't()" then enabled = false
                          0
      else enabled ? cmd.scan(/\d+/).map(&:to_i).reduce(:*) : 0
      end
    end
  end
end
