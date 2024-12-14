require_relative "../../lib/base"

# Solution for the 2024 day 14 puzzle
# https://adventofcode.com/2024/day/14
class AoC::Year2024::Solution14 < Base
  WIDTH = 101
  HEIGHT = 103

  Robot = Data.define(:x, :y, :vx, :vy) do
    def move
      Robot.new((x + vx) % WIDTH, (y + vy) % HEIGHT, vx, vy)
    end

    def quadrant
      return if x == WIDTH / 2 || y == HEIGHT / 2

      case [x < WIDTH / 2, y < HEIGHT / 2]
      in [true, true] then :top_left
      in [false, true] then :top_right
      in [true, false] then :bottom_left
      in [false, false] then :bottom_right
      end
    end
  end

  def part1
    final_positions = simulate(parse_robots, 100)
    calculate_safety_factor(count_robots_in_quadrants(final_positions))
  end

  def part2(visualize = false)
    robots = parse_robots
    (1..).each do |step|
      robots = robots.map(&:move)
      if find_horizontal_line(robots)
        puts visualize(robots) if visualize
        return step
      end
    end
  end

  def visualize(robots)
    grid = Array.new(HEIGHT) { Array.new(WIDTH, ".") }
    robots.each { |r| grid[r.y][r.x] = "#" }
    grid.map(&:join).join("\n")
  end

  private

  def parse_robots
    input_lines.map do |line|
      Robot.new(*line.scan(/-?\d+/).map(&:to_i))
    end
  end

  def simulate(robots, steps)
    steps.times.reduce(robots) { |rs, _| rs.map(&:move) }
  end

  def count_robots_in_quadrants(robots)
    counts = robots.group_by(&:quadrant).transform_values(&:count)
    %i[top_left top_right bottom_left bottom_right].to_h { |q| [q, counts[q] || 0] }
  end

  def calculate_safety_factor(quadrant_counts)
    quadrant_counts.values.reduce(:*)
  end

  def find_horizontal_line(robots)
    robots.group_by(&:y).any? do |_, robots_at_y|
      robots_at_y.map(&:x).sort!.each_cons(10).any? do |window|
        window.first + 9 == window.last && window.size == 10
      end
    end
  end
end
