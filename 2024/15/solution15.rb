# frozen_string_literal: true

require_relative "../../lib/base"

class AoC::Year2024::Solution15 < Base
  Robot = Data.define(:y, :x) do
    def move(dy, dx)
      Robot.new(y + dy, x + dx)
    end

    def coords
      [y, x]
    end
  end
  ROBOT_MOVES = {
    "^" => [-1, 0],
    "v" => [1, 0],
    "<" => [0, -1],
    ">" => [0, 1]
  }.freeze

  WIDE_BOX_MAPPINGS = {
    "." => "..",
    "@" => "@.",
    "#" => "##",
    "O" => "[]"
  }.freeze

  def part1
    warehouse, instructions = parse_warehouse
    run_robot(warehouse, instructions)
  end

  def part2
    warehouse, instructions = parse_warehouse(wide_boxes: true)
    run_robot(warehouse, instructions)
  end

  def parse_warehouse(wide_boxes: false)
    layout, instructions = input.split("\n\n")
    layout = layout.gsub(/./) { WIDE_BOX_MAPPINGS[_1] || _1 } if wide_boxes
    [layout.split("\n").map(&:chars), instructions.delete("\n")]
  end

  private

  def run_robot(warehouse, instructions)
    robot = find_robot(warehouse)
    warehouse[robot.y][robot.x] = "."

    instructions.each_char do |move|
      moves = {}
      dy, dx = ROBOT_MOVES[move]
      next unless push_boxes(warehouse, robot.y, robot.x, dy, dx, moves, true)

      moves.each { |(y, x), val| warehouse[y][x] = val }
      robot = robot.move(dy, dx)
    end

    puts warehouse.map(&:join).join("\n")
    calculate_gps_sum(warehouse)
  end

  def find_robot(warehouse)
    warehouse.each_with_index do |row, y|
      if (x = row.index("@"))
        return Robot.new(y, x)
      end
    end
  end

  def push_boxes(warehouse, y, x, dy, dx, moves, is_robot = false)
    ny, nx = y + dy, x + dx
    return false if warehouse[ny][nx] == "#"

    case warehouse[ny][nx]
    when "O", *["[", "]"].select { dy.zero? }
      return false unless push_boxes(warehouse, ny, nx, dy, dx, moves)
    when "["
      return false unless push_boxes(warehouse, ny, nx, dy, dx, moves) &&
        push_boxes(warehouse, ny, nx + 1, dy, dx, moves)
    when "]"
      return false unless push_boxes(warehouse, ny, nx, dy, dx, moves) &&
        push_boxes(warehouse, ny, nx - 1, dy, dx, moves)
    end

    moves[[ny, nx]] = warehouse[y][x]
    moves[[y, x]] ||= "f"
    true
  end

  def calculate_gps_sum(warehouse)
    warehouse.each_with_index.sum do |row, y|
      row.each_with_index.sum do |cell, x|
        cell.match?(/[O\[]/) ? y * 100 + x : 0
      end
    end
  end
end
