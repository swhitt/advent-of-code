require_relative "../../lib/base"

# Solution for the 2024 day 10 puzzle
# https://adventofcode.com/2024/day/10
class AoC::Year2024::Solution10 < Base
  DIRECTIONS = [[0, 1], [0, -1], [1, 0], [-1, 0]].freeze
  MAX_HEIGHT = 9

  def part1
    find_trailheads.sum { explore_trails(_1) }
  end

  def part2
    find_trailheads.sum { explore_trails(_1, mode: :paths) }
  end

  private

  def grid
    @grid ||= input_lines.map { _1.strip.chars.map(&:to_i) }
  end

  def find_trailheads
    grid.flat_map.with_index do |row, y|
      row.each_index.filter_map { |x| Vector[x, y] if row[x].zero? }
    end
  end

  def explore_trails(start_coord, mode: :peaks)
    results = Set.new
    initial_tracking = (mode == :peaks) ? Set.new : [start_coord]
    queue = [[start_coord, initial_tracking]]

    while (current = queue.shift)
      process_point(current, results, queue, mode)
    end

    results.size
  end

  def process_point(current, results, queue, mode)
    point, tracking = current
    return if mode == :peaks && tracking.include?(point)

    current_height = grid[point[1]][point[0]]
    if current_height == MAX_HEIGHT
      results << ((mode == :peaks) ? point : tracking)
      return
    end

    find_valid_neighbors(point, current_height, tracking).each do |new_point|
      queue << [new_point, (mode == :peaks) ? tracking : tracking + [new_point]]
    end
  end

  def find_valid_neighbors(point, current_height, visited)
    DIRECTIONS.filter_map do |dy, dx|
      new_point = Vector[point[0] + dx, point[1] + dy]
      if valid_point?(new_point, visited) && grid[new_point[1]][new_point[0]] == current_height + 1
        new_point
      end
    end
  end

  def valid_point?(point, visited)
    point[1] >= 0 &&
      point[1] < grid.size &&
      point[0] >= 0 &&
      point[0] < grid[0].size &&
      !visited.include?(point)
  end
end
