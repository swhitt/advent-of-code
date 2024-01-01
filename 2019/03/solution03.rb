require_relative "../../lib/base"

# Solution for the 2019 day 3 puzzle
# https://adventofcode.com/2019/day/3
class AoC::Year2019::Solution03 < Base
  def part1
    find_intersections.first
  end

  def part2
    find_intersections.last
  end

  def wire_paths = input_lines.map { _1.split(",") }

  def trace_wire_path(wire)
    x = y = steps = 0
    wire.each_with_object({}) do |segment, path|
      direction, distance = segment[0], segment[1..].to_i
      dx, dy = case direction
      when "R" then [1, 0]
      when "L" then [-1, 0]
      when "U" then [0, 1]
      when "D" then [0, -1]
      end

      distance.times do
        x += dx
        y += dy
        steps += 1
        path[[x, y]] ||= steps
      end
    end
  end

  def manhattan_distance(x, y) = x.abs + y.abs

  def find_intersections
    wire1_path, wire2_path = wire_paths.map { trace_wire_path(_1) }
    intersections = wire1_path.keys & wire2_path.keys

    closest_by_distance = intersections.min_by { |(x, y)| manhattan_distance(x, y) }
    fewest_combined_steps = intersections.min_by { |point| wire1_path[point] + wire2_path[point] }

    [manhattan_distance(*closest_by_distance), wire1_path[fewest_combined_steps] + wire2_path[fewest_combined_steps]]
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2019::Solution03.new
  solution.run
end
