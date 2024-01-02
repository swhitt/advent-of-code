require_relative "../../lib/base"

# Solution for the 2019 day 4 puzzle
# https://adventofcode.com/2019/day/4
class AoC::Year2019::Solution04 < Base
  def part1
    count_valid_passwords(*range)
  end

  def part2
    count_valid_passwords(*range, strict: true)
  end

  def range
    input.split("-").map(&:to_i)
  end

  def count_valid_passwords(start_range, end_range, strict: false)
    (start_range..end_range).count { |num| valid_password?(num, strict:) }
  end

  def valid_password?(num, strict: false)
    digits = num.digits.reverse
    adjacent = digits.chunk_while(&:==).any? { strict ? _1.size == 2 : _1.size >= 2 }
    ascending = digits.each_cons(2).all? { |a, b| a <= b }
    adjacent && ascending
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2019::Solution04.new
  solution.run
end
