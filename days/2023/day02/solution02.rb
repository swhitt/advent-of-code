# frozen_string_literal: true

require_relative "../../../lib/base"

class Solution02 < Base
  MAX_CUBES = { red: 12, green: 13, blue: 14 }.freeze

  def part_1
    input_lines.map do |line|
      game_id, handfuls = parse_game(line)
      all_handfuls_valid?(handfuls) ? game_id : 0
    end.sum
  end

  def part_2
    minimum_sets = input_lines.map do |line|
      game_id, handfuls = parse_game(line)
      { game_id:, power: calculate_power(find_minimum_cubes(handfuls)) }
    end
    minimum_sets.sum { |game| game[:power] }
  end

  private

  def all_handfuls_valid?(handfuls)
    handfuls.all? { |handful| handful.all? { |color, count| count <= MAX_CUBES[color] } }
  end

  def calculate_power(cubes)
    cubes[:red] * cubes[:green] * cubes[:blue]
  end

  def parse_game(game_str)
    game_id, handfuls = game_str.split(": ")
    [game_id.split.last.to_i, parse_handfuls(handfuls)]
  end

  def parse_handfuls(handfuls_str)
    handfuls_str.split("; ").map do |handful|
      parse_handful(handful)
    end
  end

  def parse_handful(handful_str)
    handful_str.split(", ").each_with_object(Hash.new(0)) do |color_count, cubes|
      count, color = color_count.split
      cubes[color.to_sym] += count.to_i
    end
  end

  def find_minimum_cubes(handfuls)
    handfuls.reduce({ red: 0, green: 0, blue: 0 }) do |min_cubes, handful|
      min_cubes.merge(handful) { |_color, old_count, new_count| [old_count, new_count].max }
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = Solution02.new
  puts "Part 1: #{solution.part_1}"
  puts "Part 2: #{solution.part_2}"
end
