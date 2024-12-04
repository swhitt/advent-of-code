require_relative "../../lib/base"

# Solution for the 2024 day 4 puzzle
# https://adventofcode.com/2024/day/4
class AoC::Year2024::Solution04 < Base
  DIRECTIONS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].freeze
  TARGET = "XMAS".freeze

  def part1
    grid.each_index.sum do |y|
      width.times.sum { |x| DIRECTIONS.count { |dy, dx| xmas_at?(y, x, dy, dx) } }
    end
  end

  def part2
    grid.each_index.sum do |y|
      width.times.count { |x| diagonal_xmas_at?(y, x) }
    end
  end

  private

  def grid
    @grid ||= input_lines.map(&:chars)
  end

  def width
    @width ||= grid[0].size
  end

  def xmas_at?(y, x, dy, dx)
    TARGET.each_char.with_index.all? do |char, i|
      ny = y + i * dy
      nx = x + i * dx
      in_bounds?(ny, nx) && grid[ny][nx] == char
    end
  end

  def diagonal_xmas_at?(y, x)
    return false unless grid[y][x] == "A"

    [[-1, -1, 1, 1], [-1, 1, 1, -1]].all? do |y1d, x1d, y2d, x2d|
      coords = [[y1d, x1d], [y2d, x2d]].map { |dy, dx| [y + dy, x + dx] }
      next false unless coords.all? { |ny, nx| in_bounds?(ny, nx) }

      coords.map { |ny, nx| grid[ny][nx] }.sort == %w[M S]
    end
  end

  def in_bounds?(y, x)
    y.between?(0, grid.size - 1) && x.between?(0, grid[0].size - 1)
  end
end
