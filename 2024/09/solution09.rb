require_relative "../../lib/base"

# Solution for the 2024 day 9 puzzle
# https://adventofcode.com/2024/day/9
class AoC::Year2024::Solution09 < Base
  def part1
    files, spaces, layout = parse_layout
    arrange_files!(files, spaces, layout)
    calculate_checksum(layout)
  end

  def part2
    files, spaces, layout = parse_layout
    compact_files!(files, spaces, layout)
    calculate_checksum(layout)
  end

  private

  def parse_layout
    files, spaces, layout = [], [], []
    pos, file_id = 0, 0

    input.strip.chars.map(&:to_i).each_with_index do |count, i|
      if i.even?
        count.times do
          files << [pos, 1, file_id]
          layout << file_id
          pos += 1
        end
        file_id += 1
      else
        spaces << [pos, count]
        layout.concat(Array.new(count))
        pos += count
      end
    end

    [files, spaces, layout]
  end

  def arrange_files!(files, spaces, layout)
    files.reverse_each do |file_pos, size, id|
      spaces.each_with_index do |(space_pos, space_size), idx|
        next unless space_pos < file_pos && size <= space_size

        layout[file_pos...(file_pos + size)] = Array.new(size)
        layout[space_pos...(space_pos + size)] = Array.new(size, id)
        spaces[idx] = [space_pos + size, space_size - size]
        break
      end
    end
  end

  def calculate_checksum(layout)
    layout.each_with_index.sum { |id, i| i * (id || 0) }
  end

  def compact_files!(files, spaces, layout)
    files_by_id = files.group_by { |_, _, id| id }
      .transform_values { _1.sort_by(&:first) }

    files_by_id.keys.sort.reverse_each do |file_id|
      positions = files_by_id[file_id]
      size = positions.size
      current_pos = positions.first[0]

      if (target_space = find_target_space(spaces, size, current_pos))
        space_pos = target_space.first
        positions.each { |pos, _, _| layout[pos] = nil }
        layout[space_pos...(space_pos + size)] = Array.new(size, file_id)
        update_space!(spaces, target_space, size)
      end
    end
  end

  def find_target_space(spaces, needed_size, current_pos)
    spaces.find { |pos, size| pos < current_pos && size >= needed_size }
  end

  def update_space!(spaces, space, used_size)
    pos, size = space
    idx = spaces.index(space)
    spaces[idx] = [pos + used_size, size - used_size]
  end
end
