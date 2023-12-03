require_relative "../../lib/base"

class AoC::Year2023::Solution03 < Base
  attr_reader :adjacent_numbers

  def initialize
    super
    process
  end

  def part1
    adjacent_numbers.values.map(&:sum).sum
  end

  def part2
    adjacent_numbers.values.select { |values| values.size == 2 }.map { |pair| pair.reduce(:*) }.sum
  end

  def process
    initialize_adjacent_numbers
    process_grid
  end

  def initialize_adjacent_numbers
    @adjacent_numbers = input_lines.each_with_index.with_object({}) do |(row, r), acc|
      row.chars.each_with_index do |char, c|
        acc[[r, c]] = [] unless char.match?(/[0-9.]/)
      end
    end
  end

  def process_grid
    input_lines.each_with_index do |row, r|
      find_numbers(row).each do |match|
        number = match[0].to_i
        edge_range = (match.begin(0) - 1)..(match.end(0))

        edge_positions = Set.new
        (-1..1).each do |row_offset|
          adjacent_row = r + row_offset
          edge_range.each do |adjacent_col|
            edge_positions.add([adjacent_row, adjacent_col])
          end
        end

        edge_positions.intersection(adjacent_numbers.keys).each do |position|
          adjacent_numbers[position] << number
        end
      end
    end
  end

  def find_numbers(text)
    text.to_enum(:scan, /\d+/).map { Regexp.last_match }
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution03.new
  solution.run
end
