require_relative "../../lib/base"

# Solution for the 2024 day 14 puzzle
# https://adventofcode.com/2024/day/14
class AoC::Year2024::Solution14 < Base
  WIDTH = 101
  HEIGHT = 103

  Robot = Data.define(:x, :y, :vx, :vy) do
    def at_step(t) = Robot.new((x + vx * t) % WIDTH, (y + vy * t) % HEIGHT, vx, vy)

    def quadrant
      return if x == WIDTH / 2 || y == HEIGHT / 2

      quadrants = {
        [true, true] => :top_left,
        [false, true] => :top_right,
        [true, false] => :bottom_left,
        [false, false] => :bottom_right
      }
      quadrants[[x < WIDTH / 2, y < HEIGHT / 2]]
    end
  end

  def part1
    robots_at_step(100)
      .then { count_robots_in_quadrants(_1) }
      .then { calculate_safety_factor(_1) }
  end

  def part2(visualize = false)
    (1..).find do |step|
      robots = robots_at_step(step)
      find_horizontal_line(robots).tap { puts visualize(robots) if visualize && _1 }
    end
  end

  def visualize(robots)
    grid = Array.new(HEIGHT) { Array.new(WIDTH, ".") }
    robots.each { grid[_1.y][_1.x] = "#" }
    grid.map(&:join).join("\n")
  end

  private

  def parsed_robots = input_lines.map { Robot.new(*_1.scan(/-?\d+/).map(&:to_i)) }
  memoize :parsed_robots

  def robots_at_step(step) = parsed_robots.map { _1.at_step(step) }

  def count_robots_in_quadrants(robots)
    robots.map(&:quadrant).tally.tap do |counts|
      %i[top_left top_right bottom_left bottom_right].each { counts[_1] ||= 0 }
    end
  end

  def calculate_safety_factor(quadrant_counts) = quadrant_counts.values.reduce(:*)

  def find_horizontal_line(robots, line_length = 10)
    robots.group_by(&:y).any? do |_, robots_at_y|
      robots_at_y.map(&:x).sort!
        .each_cons(line_length)
        .any? { |x1, *_, x_line_length| x1 + line_length - 1 == x_line_length }
    end
  end
end
