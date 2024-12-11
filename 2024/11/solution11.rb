require_relative "../../lib/base"

# Solution for the 2024 day 11 puzzle
# https://adventofcode.com/2024/day/11
class AoC::Year2024::Solution11 < Base
  def part1 = simulate_blinks(25)

  def part2 = simulate_blinks(75)

  private

  def simulate_blinks(target_blinks)
    cache = {}
    input_lines.first.split.map(&:to_i).sum do |stone|
      count_descendants(stone, 0, target_blinks, cache)
    end
  end

  def count_descendants(stone, current_blinks, target_blinks, cache)
    cache_key = "#{stone}:#{current_blinks}"
    return cache[cache_key] if cache.key?(cache_key)
    return 1 if current_blinks == target_blinks

    cache[cache_key] = next_stones(stone).sum do |next_stone|
      count_descendants(next_stone, current_blinks + 1, target_blinks, cache)
    end
  end

  def next_stones(stone)
    return [1] if stone.zero?
    return split_evenly(stone) if stone.to_s.length.even?
    [stone * 2024]
  end

  def split_evenly(num)
    str = num.to_s
    mid = str.length / 2
    [str[0...mid].to_i, str[mid..].to_i]
  end
end
