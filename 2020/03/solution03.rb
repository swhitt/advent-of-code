require_relative "../../lib/base"

class AoC::Year2020::Solution03 < Base
  def part1
    count_trees(3, 1)
  end

  def part2
    slopes = [
      [1, 1],
      [3, 1],
      [5, 1],
      [7, 1],
      [1, 2]
    ]

    slopes.map { |right, down| count_trees(right, down) }.reduce(:*)
  end

  private

  def count_trees(right, down)
    map_width = input_lines.first.length
    (0...input_lines.size).step(down).count do |y|
      x = (y / down * right) % map_width
      input_lines[y][x] == "#"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2020::Solution03.new
  solution.run
end
