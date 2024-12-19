require_relative "../../lib/base"

# Solution for the 2024 day 19 puzzle
# https://adventofcode.com/2024/day/19
class AoC::Year2024::Solution19 < Base
  def part1
    patterns, designs = input.split("\n\n")
    available = patterns.split(", ").map(&:strip)
    designs.strip.split("\n").count { |design| can_make?(design, available) }
  end

  def can_make?(design, patterns)
    dp = Array.new(design.length + 1) { |i| i == design.length }

    (design.length - 1).downto(0) do |i|
      dp[i] = patterns.any? do |pat|
        design[i, pat.length] == pat && dp[i + pat.length]
      end
    end

    dp[0]
  end

  def part2
    patterns, designs = input.split("\n\n")
    available = patterns.split(", ").map(&:strip)
    designs_to_check = designs.strip.split("\n")

    designs_to_check.sum { |design| count_ways(design, available) }
  end

  def count_ways(design, patterns)
    n = design.length
    dp = Array.new(n + 1, 0)
    dp[n] = 1

    # Work backwards from the end
    (n - 1).downto(0) do |i|
      patterns.each do |pattern|
        if pattern.length <= design.length - i &&
            design[i...(i + pattern.length)] == pattern
          dp[i] += dp[i + pattern.length]
        end
      end
    end

    dp[0]
  end
end
