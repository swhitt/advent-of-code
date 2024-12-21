require_relative "../../lib/base"

# Solution for the 2024 day 21 puzzle
# https://adventofcode.com/2024/day/21
class AoC::Year2024::Solution21 < Base
  DIRECTIONS = [[0, -1], [1, 0], [0, 1], [-1, 0]].freeze
  DIRECTION_SYMBOLS = ["^", ">", "v", "<"].freeze

  DOOR_KEYPAD = [
    ["#", "#", "#", "#", "#"],
    ["#", "7", "8", "9", "#"],
    ["#", "4", "5", "6", "#"],
    ["#", "1", "2", "3", "#"],
    ["#", "#", "0", "A", "#"],
    ["#", "#", "#", "#", "#"]
  ].freeze

  ROBOT_KEYPAD = [
    ["#", "#", "#", "#", "#"],
    ["#", "#", "^", "A", "#"],
    ["#", "<", "v", ">", "#"],
    ["#", "#", "#", "#", "#"]
  ].freeze

  def find_shortest_paths(keypad, from_key, to_key)
    start_pos = find_key_position(keypad, from_key)
    queue = [{pos: start_pos, path: [], steps: 0}]
    visited = {}
    paths = []
    min_steps = Float::INFINITY

    while (current = queue.shift)
      update_current_path(current)

      if reached_target?(keypad, current, to_key)
        paths, min_steps = update_paths(paths, current, min_steps)
        next
      end

      next if skip_visited?(visited, current, min_steps)

      enqueue_next_positions(queue, current, keypad)
    end

    format_paths(paths)
  end

  private

  def update_current_path(current)
    current[:path] << DIRECTION_SYMBOLS[current[:dir_idx]] if current[:dir_idx]
  end

  def reached_target?(keypad, current, target)
    keypad[current[:pos][1]][current[:pos][0]] == target
  end

  def update_paths(paths, current, min_steps)
    if current[:steps] < min_steps
      paths = []
      min_steps = current[:steps]
    end
    paths << current[:path] if current[:steps] == min_steps
    [paths, min_steps]
  end

  def skip_visited?(visited, current, min_steps)
    position_key = current[:pos].join("_")
    return true if visited[position_key] && visited[position_key] < current[:steps]

    visited[position_key] = current[:steps]
    current[:steps] > min_steps
  end

  def enqueue_next_positions(queue, current, keypad)
    DIRECTIONS.each_with_index do |dir, dir_idx|
      next_pos = [current[:pos][0] + dir[0], current[:pos][1] + dir[1]]
      next if wall?(keypad, next_pos)

      queue << {
        path: current[:path].clone,
        pos: next_pos,
        dir_idx: dir_idx,
        steps: current[:steps] + 1
      }
    end
  end

  def wall?(keypad, pos)
    keypad[pos[1]][pos[0]] == "#"
  end

  def format_paths(paths)
    paths.map { |path| (path.join + "A") }
  end

  def find_key_position(keypad, key)
    keypad.each_with_index do |row, y|
      row.each_with_index do |val, x|
        return [x, y] if val == key
      end
    end
  end

  def calculate_sequence_length(keypad, sequence, robot_depth, memo = {})
    memo_key = "#{sequence}_#{robot_depth}"
    return memo[memo_key] if memo.key?(memo_key)

    current_key = "A"
    total_length = 0

    sequence.each_char do |target_key|
      paths = find_shortest_paths(keypad, current_key, target_key)
      total_length += if robot_depth.zero?
        paths[0].length
      else
        paths.map { |path| calculate_sequence_length(ROBOT_KEYPAD, path, robot_depth - 1, memo) }.min
      end
      current_key = target_key
    end

    memo[memo_key] = total_length
  end

  def calculate_total_complexity(door_codes, robot_chain_length = 2)
    door_codes.sum do |code|
      code.to_i * calculate_sequence_length(DOOR_KEYPAD, code, robot_chain_length)
    end
  end

  def part1
    calculate_total_complexity(input_lines)
  end

  def part2
    calculate_total_complexity(input_lines, 25)
  end
end
