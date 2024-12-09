require_relative "../../lib/base"

# Solution for the 2024 day 8 puzzle
# https://adventofcode.com/2024/day/8
class AoC::Year2024::Solution08 < Base
  def part1
    find_part1_antinode_positions(*node_map_and_dimensions).size
  end

  def part2
    find_part2_antinode_positions(*node_map_and_dimensions).size
  end

  private

  def node_map_and_dimensions
    lines = input_lines.reject(&:empty?)
    dimensions = [lines.size, lines.first.size]
    [build_node_map(lines), dimensions]
  end

  def build_node_map(lines)
    lines.flat_map.with_index do |row, i|
      row.chars.map.with_index { |cell, j| [cell, [i, j]] unless cell == "." }
    end.compact.group_by(&:first).transform_values { _1.map(&:last) }
  end

  def find_part1_antinode_positions(nodes, dimensions)
    nodes.values.each_with_object(Set.new) do |positions, antinodes|
      positions.combination(2).flat_map { |a, b| [[a, b], [b, a]] }.each do |from, to|
        candidate = from.zip(to).map { |a, b| 2 * b - a }
        antinodes << candidate if candidate.zip(dimensions).all? { |coord, limit| coord.between?(0, limit - 1) }
      end
    end
  end

  def find_part2_antinode_positions(nodes, dimensions)
    nodes.values.select { |pos| pos.size >= 2 }.each_with_object(Set.new) do |positions, antinodes|
      # find lines from at least two antennas of the same frequency
      line_map = Hash.new { |h, k| h[k] = Set.new }

      positions.combination(2).each do |(x1, y1), (x2, y2)|
        dx, dy = x2 - x1, y2 - y1
        g = dx.gcd(dy)
        dx, dy = dx.fdiv(g), dy.fdiv(g)
        dx, dy = -dx, -dy if dx < 0 || (dx == 0 && dy < 0)

        # perpendicular normal
        offset = dy * x1 - dx * y1
        line_map[[dx, dy, offset]] << [x1, y1] << [x2, y2]
      end

      # >2 antennas,
      # enumerate all collinear points within the map
      line_map.each do |(dx, dy, _offset), ants|
        next if ants.size < 2
        antinodes.merge(all_points_on_line(ants.first, dx, dy, dimensions))
      end
    end
  end

  def all_points_on_line(base, dx, dy, dimensions)
    x0, y0 = base
    max_x, max_y = dimensions

    t_bounds = ->(coord, delta, max) {
      return [-Float::INFINITY, Float::INFINITY] if delta.zero?
      [(max - 1 - coord) / delta.to_f, -coord / delta.to_f].sort
    }

    t_min_x, t_max_x = t_bounds[x0, dx, max_x]
    t_min_y, t_max_y = t_bounds[y0, dy, max_y]
    t_min = [t_min_x, t_min_y].max.ceil
    t_max = [t_max_x, t_max_y].min.floor

    (t_min..t_max).map { |t| [x0 + t * dx, y0 + t * dy] }
  end
end
