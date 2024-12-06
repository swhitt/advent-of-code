require_relative "../../lib/base"

# Solution for the 2024 day 6 puzzle
# https://adventofcode.com/2024/day/6
class AoC::Year2024::Solution06 < Base
  DIRECTIONS = [[-1, 0], [0, 1], [1, 0], [0, -1]].freeze
  DIR_CHARS = %w[^ > v <].freeze

  def part1
    grid, start_pos, start_dir = parse_input
    simulate_guard(grid, start_pos, start_dir).size
  end

  def part2
    grid, start_pos, start_dir = parse_input

    grid.each_with_index.sum do |row, y|
      row.each_with_index.count do |cell, x|
        next false if start_pos == [y, x] || cell != "."

        grid[y][x] = "#"
        path = simulate_guard(grid, start_pos, start_dir, track_path: true)
        grid[y][x] = "."
        path&.size.to_i > 1
      end
    end
  end

  private

  def parse_input
    start_pos = nil
    start_dir = nil

    grid = input_lines.map.with_index do |line, y|
      line.chomp.chars.map.with_index do |cell, x|
        if DIR_CHARS.include?(cell)
          start_pos = [y, x]
          start_dir = cell
          "."
        else
          cell
        end
      end
    end

    [grid, start_pos, start_dir]
  end

  def simulate_guard(grid, start_pos, start_dir, track_path: false)
    height = grid.size
    width = grid[0].size
    current_dir = DIR_CHARS.index(start_dir)
    current_pos = start_pos
    visited = track_path ? Hash.new { |h, k| h[k] = Set.new } : Set.new([start_pos])
    path = track_path ? [] : nil

    loop do
      path << [current_pos, current_dir] if track_path
      y, x = current_pos
      dy, dx = DIRECTIONS[current_dir]
      next_pos = [y + dy, x + dx]
      ny, nx = next_pos

      out_of_bounds = ny.negative? || ny >= height || nx.negative? || nx >= width
      return track_path ? nil : visited if out_of_bounds
      return path if track_path && visited[next_pos].include?(current_dir)

      if grid[ny][nx] == "#"
        current_dir = (current_dir + 1) % 4
      else
        current_pos = next_pos
        track_path ? visited[next_pos].add(current_dir) : visited.add(current_pos)
      end
    end
  end
end
