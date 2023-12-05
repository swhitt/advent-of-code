require_relative "../../lib/base"

class AoC::Year2022::Solution08 < Base
  def part1
    grid.each_with_index.sum do |row, row_index|
      row.each_with_index.count do |_cell, col_index|
        visible_from_outside?(grid, row_index, col_index)
      end
    end
  end

  def visible_from_outside?(grid, row, col)
    tallest_in_row?(grid[row], col) || tallest_in_row?(grid.transpose[col], row)
  end

  def tallest_in_row?(row, index)
    before, after = row[0...index], row[index + 1..]
    height = row[index]

    before.all? { |h| h < height } || after.all? { |h| h < height }
  end

  def part2
    grid.flat_map.with_index do |row, row_index|
      row.map.with_index do |_cell, col_index|
        scenic_score(row_index, col_index)
      end
    end.max
  end

  def scenic_score(row, col)
    [[-1, 0], [1, 0], [0, -1], [0, 1]]
      .map { |delta| view_distance(row, col, delta) }
      .inject(:*)
  end

  def view_distance(row, col, delta)
    height = grid[row][col]
    distance = 0
    row += delta[0]
    col += delta[1]

    while row.between?(0, grid.size - 1) &&
        col.between?(0, grid.first.size - 1)

      distance += 1
      break if grid[row][col] >= height
      row += delta[0]
      col += delta[1]
    end

    distance
  end

  def grid
    @grid ||= input_lines.map { |line| line.chars.map(&:to_i) }
  end

  # def input
  #   "30373\n25512\n65332\n33549\n35390"
  # end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2022::Solution08.new
  solution.run
end
