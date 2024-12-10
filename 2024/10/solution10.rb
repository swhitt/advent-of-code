require_relative "../../lib/base"

# Solution for the 2024 day 10 puzzle
# https://adventofcode.com/2024/day/10
class AoC::Year2024::Solution10 < Base
  DIRECTIONS = [[0, 1], [0, -1], [1, 0], [-1, 0]].freeze

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
    grid.each_with_index.flat_map do |row, y|
      row.each_with_index.filter_map do |height, x|
        [x, y] if height.zero?
      end
    end
  end

  def explore_trails(start_x, start_y, mode: :peaks)
    height = grid.size
    width = grid[0].size
    results = Set.new
    initial_state = (mode == :peaks) ? [[start_x, start_y, Set.new]] : [[start_x, start_y, []]]

    while (x, y, tracking = initial_state.shift)
      current_height = grid[y][x]
      visited = (mode == :peaks) ? tracking : tracking + [[x, y]]
      next if mode == :peaks && tracking.include?([x, y])

      if current_height == 9
        results << ((mode == :peaks) ? [x, y] : visited)
        next
      end

      DIRECTIONS.each do |dx, dy|
        new_x = x + dx
        new_y = y + dy

        next if new_x < 0 || new_x >= width || new_y < 0 || new_y >= height
        next if visited.include?([new_x, new_y])
        next unless grid[new_y][new_x] == current_height + 1

        initial_state << [new_x, new_y, visited]
      end
    end

    results.size
  end
end
