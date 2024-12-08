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
    nodes.each_value.with_object(Set.new) do |positions, antinodes|
      positions.combination(2).flat_map { |a, b| [[a, b], [b, a]] }.each do |from, to|
        candidate = extrapolate_position(from, to)
        antinodes << candidate if valid_position?(candidate, dimensions)
      end
    end
  end

  def extrapolate_position(from, to)
    from.zip(to).map! { |a, b| 2 * b - a }
  end

  def valid_position?(pos, dimensions)
    pos.zip(dimensions).all? { |coord, limit| (0...limit).cover?(coord) }
  end

  def find_part2_antinode_positions(nodes, dimensions)
    antinodes = Set.new
    nodes.each do |_freq, positions|
      next if positions.size < 2
      line_map = Hash.new { |h, k| h[k] = Set.new }

      # lines from at least two antennas of the same frequency
      positions.combination(2).each do |(x1, y1), (x2, y2)|
        dx, dy = x2 - x1, y2 - y1
        g = dx.gcd(dy)
        dx /= g
        dy /= g
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
    antinodes
  end

  def all_points_on_line(base, dx, dy, dimensions)
    x0, y0 = base
    max_x, max_y = dimensions
    t_min_x, t_max_x = dx.zero? ? [-Float::INFINITY, Float::INFINITY] : bounds_for_t(x0, dx, max_x)
    t_min_y, t_max_y = dy.zero? ? [-Float::INFINITY, Float::INFINITY] : bounds_for_t(y0, dy, max_y)

    t_min = [t_min_x, t_min_y].max.ceil
    t_max = [t_max_x, t_max_y].min.floor

    (t_min..t_max).map { |t| [x0 + t * dx, y0 + t * dy] }
  end

  def bounds_for_t(start, d, limit)
    if d > 0
      [-start.to_f / d, (limit - 1 - start).to_f / d]
    else
      [(limit - 1 - start).to_f / d, -start.to_f / d]
    end
  end
end
