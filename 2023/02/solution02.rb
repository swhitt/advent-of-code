require_relative "../../lib/base"

# Solution for the 2023 day 2 puzzle
# https://adventofcode.com/2023/day/2
class AoC::Year2023::Solution02 < Base
  MAX_CUBES = {red: 12, green: 13, blue: 14}.freeze

  def part1
    parsed_games.sum do |game_id, handfuls|
      next 0 unless handfuls.all? { |handful| handful.all? { |color, count| count <= MAX_CUBES[color] } }

      game_id
    end
  end

  def part2
    parsed_games.sum do |_game_id, handfuls|
      handfuls.each_with_object({r: 0, g: 0, b: 0}) do |handful, min_cubes|
        min_cubes[:r] = [min_cubes[:r], handful[:red]].max
        min_cubes[:g] = [min_cubes[:g], handful[:green]].max
        min_cubes[:b] = [min_cubes[:b], handful[:blue]].max
      end.values.inject(:*)
    end
  end

  def parsed_games
    input_lines.map do |line|
      game_id, handfuls_str = line.split(": ")
      [
        game_id.split.last.to_i,
        handfuls_str.split("; ").map do |handful|
          handful.split(", ").each_with_object(Hash.new(0)) do |color_count, cubes|
            count, color = color_count.split
            cubes[color.to_sym] += count.to_i
          end
        end
      ]
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution02.new
  solution.run
end
