require_relative "../../lib/base"

# Solution for the 2023 day 14 puzzle
# https://adventofcode.com/2023/day/14
class AoC::Year2023::Solution14 < Base
  def part1
    load_on_north(north(input_lines))
  end

  def part2
    data = mega_cycles(input_lines, 1_000_000_000)
    load_on_north(data)
  end

  def load_on_north(data)
    data.each_with_index.sum do |row, y|
      row.chars.each_with_index.sum do |cell, x|
        (cell == "O") ? data.size - y : 0
      end
    end
  end

  def north(data)
    data = data.map(&:dup)
    data.each_with_index do |row, row_idx|
      row.each_char.with_index do |char, col_idx|
        next unless char == "O"
        new_row_idx = nil
        (row_idx - 1).downto(0) do |potential_row_idx|
          if data[potential_row_idx][col_idx] == "."
            new_row_idx = potential_row_idx
          else
            break
          end
        end
        if new_row_idx
          data[new_row_idx][col_idx] = "O"
          data[row_idx][col_idx] = "."
        end
      end
    end

    data
  end

  def south(data)
    north(data.reverse).reverse
  end

  def west(data)
    transpose_chars(
      north(
        transpose_chars(data)
      )
    )
  end

  def east(data)
    transpose_chars(
      north(
        transpose_chars(data).reverse
      ).reverse
    )
  end

  def cycle(data)
    east(south(west(north(data))))
  end

  def mega_cycles(initial_state, total_iterations)
    # we store all cycles until we find a repeat
    sequence = []

    current_state = initial_state

    cycle_start_index = nil
    until cycle_start_index
      sequence << current_state
      next_state = cycle(current_state)
      cycle_start_index = sequence.index(next_state)
      current_state = next_state
    end

    cycle_length = sequence.size - cycle_start_index

    final_state_index = if total_iterations < cycle_start_index
      total_iterations
    else
      (total_iterations - cycle_start_index) % cycle_length + cycle_start_index
    end

    sequence[final_state_index]
  end

  def transpose_chars(data)
    data.map(&:chars).transpose.map(&:join)
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution14.new
  solution.run
end
