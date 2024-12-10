require_relative "../../lib/base"

# Solution for the 2024 day 10 puzzle
# https://adventofcode.com/2024/day/10
class AoC::Year2024::Solution10 < Base
  DIRECTIONS = [[0, 1], [0, -1], [1, 0], [-1, 0]].freeze
  MAX_HEIGHT = 9

  def part1
    find_trailheads.sum { |x, y| explore_trails(x, y) }
  end

  def part2
    find_trailheads.sum { |x, y| explore_trails(x, y, mode: :paths) }
  end

  private

  def grid
    @grid ||= input_lines.map { _1.strip.chars.map(&:to_i) }
  end

  def find_trailheads
    grid.flat_map.with_index do |row, y|
      row.each_index.filter_map { [_1, y] if row[_1].zero? }
    end
  end

  def explore_trails(start_x, start_y, mode: :peaks)
    results = Set.new
    initial_tracking = (mode == :peaks) ? Set.new : [[start_x, start_y]]
    queue = [[start_x, start_y, initial_tracking]]

    while (current = queue.shift)
      process_point(current, results, queue, mode)
    end

    results.size
  end

  def process_point(current, results, queue, mode)
    x, y, tracking = current
    return if mode == :peaks && tracking.include?([x, y])

    current_height = grid[y][x]
    if current_height == MAX_HEIGHT
      results << ((mode == :peaks) ? [x, y] : tracking)
      return
    end

    find_valid_neighbors(x, y, current_height, tracking).each do |new_x, new_y|
      queue << [new_x, new_y, (mode == :peaks) ? tracking : tracking + [[new_x, new_y]]]
    end
  end

  def find_valid_neighbors(x, y, current_height, visited)
    DIRECTIONS.filter_map do |dx, dy|
      new_x, new_y = x + dx, y + dy
      if valid_point?(new_x, new_y, visited) && grid[new_y][new_x] == current_height + 1
        [new_x, new_y]
      end
    end
  end

  def valid_point?(x, y, visited)
    x >= 0 &&
      x < grid[0].size &&
      y >= 0 &&
      y < grid.size &&
      !visited.include?([x, y])
  end
end
