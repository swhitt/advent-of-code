require_relative "../../lib/base"

# Solution for the 2023 day 21 puzzle
# https://adventofcode.com/2023/day/21
class AoC::Year2023::Solution21 < Base
  def part1(max_steps: 64)
    garden, (start_x, start_y) = parse_garden(input)
    bfs(garden, start_x, start_y, max_steps:)
  end

  def part2
    # do it second
  end

  def parse_garden(input)
    garden = input.lines.map(&:chomp)
    garden.each_with_index do |line, y|
      x = line.index("S")
      if x
        return [garden, [x, y]]
      end
    end
  end

  def bfs(garden, start_x, start_y, max_steps: 64)
    directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]
    queue = [[start_x, start_y, 0]]
    visited_at_step = Hash.new { |h, k| h[k] = Set.new }

    until queue.empty?
      x, y, steps = queue.shift
      next unless x.between?(0, garden[0].length - 1) && y.between?(0, garden.size - 1)
      next if garden[y][x] == "#"
      next if visited_at_step[steps].include?([x, y])
      next if steps > max_steps

      visited_at_step[steps].add([x, y])

      directions.each do |dx, dy|
        queue.push([x + dx, y + dy, steps + 1])
      end
    end

    visited_at_step[max_steps].size
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution21.new
  solution.run
end
