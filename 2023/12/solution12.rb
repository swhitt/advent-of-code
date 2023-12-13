# frozen_string_literal: true

require_relative "../../lib/base"

class AoC::Year2023::Solution12 < Base
  def part1
    process_lines
  end

  def part2
    process_lines(multiplier: 5)
  end

  def process_lines(multiplier: 1)
    input_lines.sum do |line|
      pattern, groups_s = line.split(" ")
      groups = groups_s.split(",").map(&:to_i)

      if multiplier > 1
        pattern = ([pattern] * multiplier).join("?")
        groups *= multiplier
      end

      broken_spring_arrangements(pattern, groups)
    end
  end

  def broken_spring_arrangements(pattern, groups)
    return 1 if pattern.empty? && groups.empty? # Everything is matched and no more pattern!
    return 0 if pattern.empty? || groups.empty? # We ran out of pattern or groups but not both

    case pattern[0]
    when "."
      # Skip the operational springs at the start of the pattern
      broken_spring_arrangements(pattern[1..], groups)
    when "?"
      # Check both possibilities for the unknown spring
      broken_spring_arrangements(pattern.sub("?", "."), groups) +
        broken_spring_arrangements(pattern.sub("?", "#"), groups)
    when "#"
      # The first spring is definitely broken
      first_group_size = groups.first
      if groups.empty? || (pattern.length < first_group_size) || pattern[0...first_group_size].include?(".")
        # The pattern doesn't match the first group
        0
      elsif groups.length == 1
        # If there are no more broken springs after the current group, this is a valid arrangement
        pattern[first_group_size..].include?("#") ? 0 : 1
      elsif pattern.length < first_group_size + 1 || pattern[first_group_size] == "#"
        # there are more groups but no patterns OR there's a broken spring immediately after the current group
        0
      else
        # We have a complete match and more groups to go
        broken_spring_arrangements(pattern[(first_group_size + 1)..], groups[1..])
      end
    else
      raise "Unexpected character"
    end
  end

  memoize(:broken_spring_arrangements)
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution12.new
  solution.run
end
