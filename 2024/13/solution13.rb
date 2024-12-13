require_relative "../../lib/base"

# Solution for the 2024 day 13 puzzle
# https://adventofcode.com/2024/day/13
class AoC::Year2024::Solution13 < Base
  Machine = Data.define(:button_a, :button_b, :prize) do
    def solve_minimum_tokens(offset: 0)
      # a * button_a + b * button_b = prize + offset
      ax, ay = button_a
      bx, by = button_b
      px, py = prize[0] + offset, prize[1] + offset

      det = ax * by - ay * bx
      return nil if det.zero?

      a = (px * by - py * bx) / det.to_f
      b = (ax * py - ay * px) / det.to_f

      return nil unless a.round == a && b.positive? && b.round == b && b.positive?

      a, b = a.to_i, b.to_i
      x = a * ax + b * bx
      y = a * ay + b * by

      return nil unless x == px && y == py

      (a * 3) + b
    end
  end

  def machines
    machines = []
    current = {}

    input.each_line(chomp: true) do |line|
      next if line.empty?

      case line
      when /^Button A: X\+(\d+), Y\+(\d+)$/
        current[:button_a] = [$1.to_i, $2.to_i]
      when /^Button B: X\+(\d+), Y\+(\d+)$/
        current[:button_b] = [$1.to_i, $2.to_i]
      when /^Prize: X=(\d+), Y=(\d+)$/
        current[:prize] = [$1.to_i, $2.to_i]
        if current.size == 3
          machines << Machine.new(current[:button_a], current[:button_b], current[:prize])
          current = {}
        end
      end
    end

    machines
  end

  def part1
    machines.sum { _1.solve_minimum_tokens || 0 }
  end

  def part2
    machines.sum { _1.solve_minimum_tokens(offset: 10_000_000_000_000) || 0 }
  end
end
