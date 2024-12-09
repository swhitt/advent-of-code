require_relative "../../lib/base"

# Solution for the 2024 day 8 puzzle
# https://adventofcode.com/2024/day/8
class AoC::Year2024::Solution08 < Base
  def part1
    dimensions = [grid.size, grid.first.size]
    find_nodes(grid).values.flat_map do |positions|
      positions.combination(2).flat_map do |first, second|
        vector = second.zip(first).map! { |a, b| a - b }
        [
          first.zip(vector).map! { |pos, v| pos - v },
          second.zip(vector).map! { |pos, v| pos + v }
        ]
      end
    end.uniq.count { |x, y| in_bounds?(x, y, dimensions) }
  end

  def part2
    dimensions = [grid.size, grid.first.size]
    find_nodes(grid).values.flat_map do |positions|
      positions.combination(2).flat_map do |first, second|
        vector = second.zip(first).map! { |a, b| a - b }
        [
          collect_points(first, vector, -1, dimensions),
          collect_points(second, vector, 1, dimensions)
        ]
      end
    end.flatten(1).uniq!.size
  end

  private

  def grid
    @grid ||= input_lines.reject(&:empty?)
  end

  def in_bounds?(x, y, dimensions)
    x.between?(0, dimensions[0] - 1) && y.between?(0, dimensions[1] - 1)
  end

  def collect_points(start, vector, direction, dimensions)
    pos = start.dup
    [].tap do |points|
      while in_bounds?(*pos, dimensions)
        points << pos.dup
        pos.each_index { |i| pos[i] += vector[i] * direction }
      end
    end
  end

  def find_nodes(grid)
    Hash.new { |h, k| h[k] = [] }.tap do |nodes|
      grid.each_with_index do |row, i|
        row.chars.each_with_index do |cell, j|
          nodes[cell] << [i, j] unless cell == "."
        end
      end
    end
  end
end
