require_relative "../../lib/base"

class AoC::Year2023::Solution11 < Base
  def part1
    calculate_distance_with_expansion(2)
  end

  def part2(expansion_factor: 1_000_000)
    calculate_distance_with_expansion(expansion_factor)
  end

  def calculate_distance_with_expansion(expansion_factor)
    empty_rows, empty_cols = identify_empty_rows_and_columns
    galaxy_coordinates = assign_coordinates
    calculate_total_manhattan_distance(galaxy_coordinates, empty_rows, empty_cols, expansion_factor)
  end

  def assign_coordinates
    galaxy_number = 1

    input_lines.each_with_index.each_with_object({}) do |(row, i), galaxy_coords|
      row.chars.each_with_index do |cell, j|
        next unless cell == "#"

        galaxy_coords[galaxy_number] = [i, j]
        galaxy_number += 1
      end
    end
  end

  def identify_empty_rows_and_columns
    empty_rows = input_lines.each_index.select { |i| !input_lines[i].include?("#") }.to_set
    empty_cols = (0...input_lines.first.length).select { |j| input_lines.all? { |row| row[j] == "." } }.to_set

    [empty_rows, empty_cols]
  end

  def calculate_total_manhattan_distance(galaxy_coords, empty_rows, empty_cols, expansion_factor)
    galaxy_coords.to_a.combination(2).sum do |(galaxy1, coords1), (galaxy2, coords2)|
      row_distance, col_distance = calculate_individual_distances(coords1, coords2)

      empty_rows_between = empty_rows.count { |row| in_range?(row, coords1[0], coords2[0]) }
      empty_cols_between = empty_cols.count { |col| in_range?(col, coords1[1], coords2[1]) }

      row_distance += empty_rows_between * (expansion_factor - 1)
      col_distance += empty_cols_between * (expansion_factor - 1)

      row_distance + col_distance
    end
  end

  def calculate_individual_distances(coords1, coords2)
    [(coords1[0] - coords2[0]).abs, (coords1[1] - coords2[1]).abs]
  end

  def in_range?(value, start, finish)
    Range.new(*[start, finish].sort).cover?(value)
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution11.new
  solution.run
end
