require_relative "../../lib/base"

# Solution for the 2024 day 17 puzzle
# https://adventofcode.com/2024/day/17
class AoC::Year2024::Solution18 < Base
  def part1
    initialize_grid
    simulate_byte_falls

    bfs_shortest_path
  end

  def part2
    initialize_grid
    find_blockade_byte
  end

  def find_blockade_byte
    input.lines.map { _1.split(",").map(&:to_i) }.find do |x, y|
      @grid[y][x] = "#"
      !bfs_shortest_path
    end.then { "#{_1[0]},#{_1[1]}" }
  end

  private

  def initialize_grid
    @grid = Array.new(71) { ["."] * 71 }
  end

  def simulate_byte_falls
    input.lines
      .map { _1.split(",").map(&:to_i) }
      .first(1024)
      .each { @grid[_2][_1] = "#" }
  end

  def bfs_shortest_path
    start = [0, 0]
    goal = [70, 70]
    queue = Queue.new
    queue << [start, 0]
    visited = Set.new([start])

    until queue.empty?
      position, steps = queue.pop
      x, y = position

      return steps if position == goal

      [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |dx, dy|
        new_x, new_y = x + dx, y + dy
        next unless (0..70).cover?(new_x) && (0..70).cover?(new_y)

        new_position = [new_x, new_y]
        next if @grid[new_y][new_x] != "." || visited.include?(new_position)

        visited << new_position
        queue << [new_position, steps + 1]
      end
    end
    nil
  end
end
