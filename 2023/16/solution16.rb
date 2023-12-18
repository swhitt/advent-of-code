require_relative "../../lib/base"

MOVEMENTS = {
  right: {".": :right, "/": :up, "\\": :down, "|": [:up, :down], "-": :right},
  left: {".": :left, "/": :down, "\\": :up, "|": [:up, :down], "-": :left},
  up: {".": :up, "/": :right, "\\": :left, "|": :up, "-": [:left, :right]},
  down: {".": :down, "/": :left, "\\": :right, "|": :down, "-": [:left, :right]}
}.freeze

MOVEMENT_DELTAS = {
  up: [-1, 0],
  down: [1, 0],
  left: [0, -1],
  right: [0, 1]
}.freeze

# Solution for the 2023 day 16 puzzle
# https://adventofcode.com/2023/day/16
class AoC::Year2023::Solution16 < Base
  def part1
    simulate_beam(0, 0, :right)
  end

  def part2
    all_sides_start_conditions.map { simulate_beam(*_1) }.max
  end

  def grid
    @grid ||= input_lines.map(&:chomp).map(&:chars)
  end

  def simulate_beam(row, col, direction)
    visited = Set.new
    queue = [[row, col, direction]]

    while queue.any?
      row, col, direction = queue.shift
      next unless in_bounds?(row, col)

      # we don't need to continue if we've already visited this position going in this direction
      position_key = [row, col, direction]
      next if visited.include?(position_key)

      visited.add(position_key)

      cell_value = grid[row][col].to_sym
      new_directions = MOVEMENTS[direction][cell_value]
      new_directions = [new_directions] unless new_directions.is_a?(Array)

      new_directions.each do |new_direction|
        row_delta, col_delta = MOVEMENT_DELTAS[new_direction]
        next_row, next_col = row + row_delta, col + col_delta
        next_position_key = [next_row, next_col, new_direction]
        unless visited.include?(next_position_key) || !in_bounds?(next_row, next_col)
          queue << [next_row, next_col, new_direction]
        end
      end
    end
    visited.map { |row, col, _| [row, col] }.uniq.count
  end

  def in_bounds?(row, col)
    row >= 0 && row < grid.length && col >= 0 && col < grid[0].length
  end

  def all_sides_start_conditions
    size_rows = grid.size
    size_cols = grid.first.size

    left_and_right = (0...size_rows).flat_map do |row|
      [[row, 0, :right], [row, size_cols - 1, :left]]
    end

    top_and_bottom = (0...size_cols).flat_map do |col|
      [[0, col, :down], [size_rows - 1, col, :up]]
    end

    left_and_right + top_and_bottom
  end

  def print_visited_grid(visited_positions)
    size_rows = grid.size
    size_cols = grid.first.size
    visual_grid = Array.new(size_rows) { Array.new(size_cols, ".") }

    visited_positions.each { |row, col| visual_grid[row][col] = "#" }

    visual_grid.each { puts _1.join }
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution16.new
  solution.run
end
