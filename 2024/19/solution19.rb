require_relative "../../lib/base"

# Solution for the 2024 day 19 puzzle
# https://adventofcode.com/2024/day/19
class AoC::Year2024::Solution19 < Base
  def part1
    parse_input.then do |patterns, designs|
      designs.count { can_make?(_1, patterns) }
    end
  end

  def part2
    parse_input.then do |patterns, designs|
      designs.sum { count_ways(_1, patterns) }
    end
  end

  private

  def parse_input
    patterns, designs = input.split("\n\n")
    [
      patterns.split(", ").map(&:strip),
      designs.lines(chomp: true)
    ]
  end

  def can_make?(design, patterns)
    dp = Array.new(design.length + 1) { _1 == design.length }

    (design.length - 1).downto(0) do |i|
      dp[i] = patterns.any? do |pattern|
        design[i, pattern.length] == pattern && dp[i + pattern.length]
      end
    end

    dp.first
  end

  def count_ways(design, patterns)
    dp = Array.new(design.length + 1, 0)
    dp[-1] = 1

    (design.length - 1).downto(0) do |i|
      dp[i] = patterns.sum do |pattern|
        next 0 if pattern.length > design.length - i
        (design[i...(i + pattern.length)] == pattern) ? dp[i + pattern.length] : 0
      end
    end

    dp.first
  end
end
