require_relative "../../lib/base"

# Solution for the 2024 day 12 puzzle
# https://adventofcode.com/2024/day/12
class AoC::Year2024::Solution12 < Base
  DIRECTIONS = [
    Vector[0, -1],
    Vector[0, 1],
    Vector[-1, 0],
    Vector[1, 0]
  ].freeze

  def part1 = find_regions.sum { |region| region.size * count_external_edges(region) }

  def part2 = find_regions.sum { |region| region.size * count_unique_sides(region) }

  private

  def find_regions
    seen = Set.new
    grid = parse_grid

    grid.keys.filter_map do |point|
      next if seen.include?(point)
      region = flood_fill(point, grid, seen)
      region if region.any?
    end
  end

  def flood_fill(start, grid, seen)
    region = Set.new
    queue = Queue.new
    queue << start

    until queue.empty?
      current = queue.pop
      next if region.include?(current)

      region << current
      seen << current

      DIRECTIONS.each do |dir|
        next_point = current + dir
        queue << next_point if grid[next_point] == grid[current]
      end
    end

    region
  end

  def count_external_edges(region)
    region.sum { |point| DIRECTIONS.count { |dir| !region.include?(point + dir) } }
  end

  def count_unique_sides(region)
    sides = Set.new

    region.each do |point|
      DIRECTIONS.each do |dir|
        next if region.include?(point + dir)

        current = point
        walk_dir = Vector[-dir[1], dir[0]]

        while region.include?(current + walk_dir) && !region.include?(current + dir + walk_dir)
          current += walk_dir
        end

        sides << [current, dir]
      end
    end

    sides.size
  end

  def parse_grid
    input_lines.each_with_index.flat_map do |line, y|
      line.chars.each_with_index.map { |char, x| [Vector[x, y], char] }
    end.to_h
  end
end
