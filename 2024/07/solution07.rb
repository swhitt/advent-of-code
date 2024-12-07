require_relative "../../lib/base"

# Solution for the 2024 day 7 puzzle
# https://adventofcode.com/2024/day/7
class AoC::Year2024::Solution07 < Base
  OPERATORS = {
    :+ => ->(a, b) { a + b },
    :* => ->(a, b) { a * b },
    :"||" => ->(a, b) { (a.to_s + b.to_s).to_i }
  }

  def part1
    solve([:+, :*])
  end

  def part2
    solve([:+, :*, :"||"])
  end

  private

  def solve(allowed_ops)
    input_lines.sum do |line|
      target, numbers = parse_line(line)
      reachable?(numbers, target, allowed_ops) ? target : 0
    end
  end

  def parse_line(line)
    target, numbers = line.split(":")
    [target.to_i, numbers.split.map(&:to_i)]
  end

  def reachable?(numbers, target, ops, cache = {})
    return cache[[numbers, target]] if cache.key?([numbers, target])
    cache[[numbers, target]] = if numbers.size == 1
      numbers.first == target
    else
      ops.any? { |op| reachable?([OPERATORS[op].call(numbers[0], numbers[1]), *numbers.drop(2)], target, ops, cache) }
    end
  end
end
