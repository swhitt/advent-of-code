require_relative "../../lib/base"

# Solution for the 2024 day 13 puzzle
# https://adventofcode.com/2024/day/13
class AoC::Year2024::Solution13 < Base
  Machine = Data.define(:button_a, :button_b, :prize) do
    def solve_minimum_tokens(offset: 0)
      # a * button_a + b * button_b = prize + offset
      ax, ay = button_a
      bx, by = button_b
      px, py = prize.map { _1 + offset }

      det = ax * by - ay * bx
      return if det.zero?

      a = (px * by - py * bx) / det.to_f
      b = (ax * py - ay * px) / det.to_f

      return unless [a, b].all? { _1.positive? && _1.round == _1 }

      a, b = a.to_i, b.to_i

      return unless [a * ax + b * bx, a * ay + b * by] == [px, py]

      a * 3 + b
    end
  end

  def part1 = machines.sum { _1.solve_minimum_tokens || 0 }

  def part2 = machines.sum { _1.solve_minimum_tokens(offset: 10_000_000_000_000) || 0 }

  def machines
    input.each_line(chomp: true)
      .slice_before(/^Button A/)
      .filter_map do |chunk|
      nums = chunk.join
        .scan(/(?:X\+|X=|Y\+|Y=)(\d+)/)
        .map { _1[0].to_i }

      next unless nums.size == 6

      button_a = nums[0..1]
      button_b = nums[2..3]
      prize = nums[4..5]

      Machine.new(button_a, button_b, prize)
    end
  end
end
