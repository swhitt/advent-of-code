require_relative "../../lib/base"

# Solution for the 2019 day 1 puzzle
# https://adventofcode.com/2019/day/1
class AoC::Year2019::Solution01 < Base
  def part1
    masses.sum { calculate_fuel(_1) }
  end

  def part2
    masses.sum { calculate_total_fuel(_1) }
  end

  def masses
    input_lines.map(&:to_i)
  end

  def calculate_fuel(mass)
    (mass / 3).floor - 2
  end

  def calculate_total_fuel(mass)
    total_fuel = 0

    while mass > 0
      mass = calculate_fuel(mass)
      total_fuel += mass if mass > 0
    end

    total_fuel
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2019::Solution01.new
  solution.run
end
