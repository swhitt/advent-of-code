require_relative "../../lib/base"

DIRECTIONS = {
  north: 0,
  east: 1,
  south: 2,
  west: 3
}.freeze

ANSI_ART = {
  "F" => "┌",
  "L" => "└",
  "7" => "┐",
  "J" => "┘",
  "|" => "│",
  "-" => "─",
  "S" => "┼",
  "." => " "
}.freeze

class Pipe
  attr_accessor :connections, :is_starting_pipe, :original_char

  def initialize(pipe)
    @connections = pipe_to_directions(pipe)
    @is_starting_pipe = pipe == "S"
    @original_char = pipe
  end

  def pipe_to_directions(pipe)
    case pipe
    when "|" then [:north, :south].to_set
    when "-" then [:east, :west].to_set
    when "L" then [:north, :east].to_set
    when "J" then [:north, :west].to_set
    when "7" then [:south, :west].to_set
    when "F" then [:south, :east].to_set
    when "." then Set.new
    when "S" then DIRECTIONS.keys.to_set # we will find the actual connections later
    else raise "Unknown pipe: #{pipe}"
    end
  end

  def connected?(other, direction)
    connections.include?(direction) && other.connections.include?(Pipe.get_opposite_direction(direction))
  end

  def self.get_opposite_direction(direction)
    DIRECTIONS.key((DIRECTIONS[direction] + 2) % 4)
  end
end

# Solution for the 2023 day 10 puzzle
# https://adventofcode.com/2023/day/10
class AoC::Year2023::Solution10 < Base
  attr_reader :starting_row, :starting_col, :steps

  def part1(print_map: false)
    find_steps
    visualize_map if print_map
    steps.size / 2
  end

  def part2(print_map: false)
    find_steps
    count_inside(print_map:)
  end

  def find_steps
    @starting_row, @starting_col = find_starting_pipe
    set_start_connections
    @steps = get_steps(starting_row, starting_col)
  end

  def data
    @data ||= input_lines.map do |line|
      line.strip.chars.map { |char| Pipe.new(char) }
    end
  end

  def get_next_position(direction, start_position = [0, 0])
    x, y = start_position
    case direction
    when :north then [x - 1, y]
    when :east then [x, y + 1]
    when :south then [x + 1, y]
    when :west then [x, y - 1]
    else raise "Unknown direction: #{direction}"
    end
  end

  def find_starting_pipe
    data.each_with_index do |row, row_index|
      col_index = row.index(&:is_starting_pipe)
      return [row_index, col_index] if col_index
    end
    raise "No starting pipe found"
  end

  def set_start_connections
    pipe = data[starting_row][starting_col]
    pipe.connections.select! do |direction|
      next_row, next_col = get_next_position(direction, [starting_row, starting_col])
      next unless next_row.between?(0, data.size - 1) && next_col.between?(0, data.first.size - 1)
      pipe.connected?(data[next_row][next_col], direction)
    end
  end

  def get_steps(starting_row, starting_col)
    steps = Set.new([[starting_row, starting_col]])
    current_position = [starting_row, starting_col]
    current_direction = data[starting_row][starting_col].connections.first

    until steps.include?(next_position = get_next_position(current_direction, current_position))
      steps.add(next_position)
      current_pipe = data.dig(*next_position)
      current_direction = next_direction(current_pipe, current_direction)
      current_position = next_position
    end

    steps
  end

  def next_direction(current_pipe, current_direction)
    current_pipe.connections.find do |direction|
      direction != Pipe.get_opposite_direction(current_direction)
    end
  end

  def count_inside(print_map: false)
    total_inside = 0
    data.each_with_index do |row, row_index|
      count_north, count_south = 0, 0
      row.each_with_index do |pipe, col_index|
        if steps.include?([row_index, col_index])
          count_north += 1 if pipe.connections.include?(:north)
          count_south += 1 if pipe.connections.include?(:south)
          print ANSI_ART[pipe.original_char] if print_map
        elsif [count_north, count_south].min.odd?
          print "+" if print_map
          total_inside += 1
        elsif print_map
          print " "
        end
      end
      print "\n" if print_map
    end
    total_inside
  end

  def visualize_map
    data.each_with_index do |row, row_index|
      row.each_with_index do |pipe, col_index|
        print steps.include?([row_index, col_index]) ? ANSI_ART[pipe.original_char] : "."
      end
      puts
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution10.new
  solution.run
end
