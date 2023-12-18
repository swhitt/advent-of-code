require_relative "../../lib/base"

# Solution for the 2023 day 18 puzzle
# https://adventofcode.com/2023/day/18
class AoC::Year2023::Solution18 < Base
  HEX_DIRECTION_MAP = {"0" => "R", "1" => "D", "2" => "L", "3" => "U"}.freeze
  DIRECTIONS = {"R" => [0, 1], "D" => [-1, 0], "L" => [0, -1], "U" => [1, 0]}.freeze

  def part1
    calculate_lava_volume
  end

  def part2
    calculate_lava_volume(part2: true)
  end

  def calculate_lava_volume(part2: false)
    path = [[0, 0]]

    input_lines.each do |line|
      direction, length, color_code_with_parens = line.split
      color_code = color_code_with_parens[2...-1] # Extract hex code without parentheses

      if part2
        hex_direction = color_code[-1]
        direction = HEX_DIRECTION_MAP[hex_direction]
        direction_vector = DIRECTIONS[direction]
        length = color_code[0...5].to_i(16)
      else
        direction_vector = DIRECTIONS[direction]
        length = length.to_i
      end

      extend_path(path, direction_vector, length)
    end

    calculate_lava_volume_from_path(path).to_i
  end

  def extend_path(path, direction_vector, length)
    current_position = path.last
    new_position = [current_position[0] + length * direction_vector[0],
      current_position[1] + length * direction_vector[1]]
    path << new_position
  end

  def calculate_lava_volume_from_path(path)
    area = Util.polygon_area(path)
    perimeter_length = path.each_cons(2).sum { |(x1, y1), (x2, y2)| (x2 - x1).abs + (y2 - y1).abs }
    # Pick's theroem solved to find interior points
    interior_points = area + 1 - perimeter_length / 2
    # Every point corresponds to 1 m^3 of lava, to get them all we sum the perimiter points with the interior points
    interior_points + perimeter_length
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution18.new
  solution.run
end
