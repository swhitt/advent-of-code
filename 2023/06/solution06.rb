require_relative "../../lib/base"

# Solution for the 2023 day 6 puzzle
# https://adventofcode.com/2023/day/6
class AoC::Year2023::Solution06 < Base
  def part1
    times, distances = input_lines.map { |line| line.scan(/\d+/).map(&:to_i) }
    calculate_wins(times.zip(distances))
  end

  def part2
    calculate_wins([input_lines.map { |line| line.delete("^0-9").to_i }])
  end

  private

  def calculate_wins(races)
    races.map { |time, distance| (1...time).count { |hold| (time - hold) * hold > distance } }.reduce(:*)
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution06.new
  solution.run
end
