require_relative "../../lib/base"

class AoC::Year2021::Solution02 < Base
  def part1
    state = {horizontal_position: 0, depth: 0}
    process_commands(state) do |state, direction, value|
      handle_movement(state, direction, value)
    end
    state[:horizontal_position] * state[:depth]
  end

  def part2
    state = {horizontal_position: 0, depth: 0, aim: 0}
    process_commands(state) do |state, direction, value|
      handle_aimed_movement(state, direction, value)
    end
    state[:horizontal_position] * state[:depth]
  end

  private

  def process_commands(state)
    input_lines.each do |command|
      direction, value = command.split
      value = value.to_i
      yield(state, direction, value)
    end
  end

  def handle_movement(state, direction, value)
    case direction
    when "forward"
      state[:horizontal_position] += value
    when "down"
      state[:depth] += value
    when "up"
      state[:depth] -= value
    end
  end

  def handle_aimed_movement(state, direction, value)
    case direction
    when "forward"
      state[:horizontal_position] += value
      state[:depth] += state[:aim] * value
    when "down"
      state[:aim] += value
    when "up"
      state[:aim] -= value
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2021::Solution02.new
  solution.run
end
