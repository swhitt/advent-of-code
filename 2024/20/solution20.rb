require_relative "../../lib/base"

# Solution for the 2024 day 20 puzzle
# https://adventofcode.com/2024/day/20
class AoC::Year2024::Solution20 < Base
  MIN_SAVE = 100

  def part1
    grid = input_chars
    start = find_start(grid)
    path = find_path(grid, start)

    calculate_cheats(path)
  end

  def part2
    grid = input_chars
    start = find_start(grid)
    path = find_path(grid, start)

    calculate_cheats(path, max_cheat: 20)
  end

  private

  def find_start(grid)
    r = grid.find_index { |row| row.include?("S") }
    c = grid[r].find_index("S")
    [r, c]
  end

  def find_path(grid, start)
    dirs = [[-1, 0], [0, 1], [1, 0], [0, -1]]
    seen = Set[start.to_s]
    queue = [start]
    prevs = {}

    queue.each_with_index do |curr, index|
      return build_path(prevs, curr) if grid.dig(curr[0], curr[1]) == "E"

      dirs.each do |dr, dc|
        other = [curr[0] + dr, curr[1] + dc]
        other_key = other.to_s
        next if seen.include?(other_key) || !valid_move?(grid, other)

        queue << other
        prevs[other_key] = curr
        seen << other_key
      end
    end

    raise "Path not found"
  end

  def valid_move?(grid, pos)
    ["E", "."].include?(grid.dig(pos[0], pos[1]))
  end

  def build_path(prevs, curr)
    path = []
    while curr
      path << curr
      curr = prevs[curr.to_s]
    end
    path.reverse
  end

  def manhattan_distance(pos1, pos2)
    (pos2[0] - pos1[0]).abs + (pos2[1] - pos1[1]).abs
  end

  def calculate_cheats(path, max_cheat: 2)
    path.each_with_index.sum do |pos1, i|
      path[(i + 1)..].each_with_index.count do |pos2, j|
        new_dist = manhattan_distance(pos1, pos2)
        prev_dist = j + 1
        new_dist <= max_cheat && prev_dist - new_dist >= MIN_SAVE
      end
    end
  end
end
