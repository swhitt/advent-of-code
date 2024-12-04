require_relative "../../lib/base"
require "json"

# Solution for the 2022 day 13 puzzle
# https://adventofcode.com/2022/day/13
class AoC::Year2022::Solution13 < Base
  def part1
    input_lines("\n\n").map { |pair| pair.split("\n").map { JSON.parse(_1) } }.then do |pairs|
      pairs.map.with_index(1) { |pair, i| (compare(*pair) == -1) ? i : 0 }.sum
    end
  end

  def part2
    dividers = [[[2]], [[6]]]
    packets = input_lines.reject(&:empty?).map! { JSON.parse(_1) } + dividers
    sorted = packets.sort { |a, b| compare(a, b) }
    dividers.map { sorted.index(_1) + 1 }.reduce(:*)
  end

  private

  def compare(left, right)
    case [left, right]
    in [Integer, Integer] then left <=> right
    in [Array, Integer] then compare(left, [right])
    in [Integer, Array] then compare([left], right)
    in [Array, Array]
      left.zip(right).each do |l, r|
        return 1 if r.nil?
        return -1 if l.nil?
        result = compare(l, r)
        return result unless result.zero?
      end
      left.size <=> right.size
    end
  end
end
