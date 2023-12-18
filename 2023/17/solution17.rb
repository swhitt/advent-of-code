require_relative "../../lib/base"

# Solution for the 2023 day 17 puzzle
# https://adventofcode.com/2023/day/17
class AoC::Year2023::Solution17 < Base
  def part1
    find_least_heat_loss_path
  end

  def part2
    find_least_heat_loss_path(part2: true)
  end

  def heat_loss_grid
    @heat_loss_grid ||= input_lines.map { _1.chomp.chars.map(&:to_i) }
  end

  def find_least_heat_loss_path(part2: false)
    visited_positions = Set.new
    start_down = [0, 0, 0, [1, 0]]
    start_right = [0, 0, 0, [0, 1]]
    heat_loss_to_position = {start_down => 0, start_right => 0}
    queue = PQueue.new([start_down, start_right]) { |a, b| heat_loss_to_position[a] < heat_loss_to_position[b] }
    factory_position = [heat_loss_grid.length - 1, heat_loss_grid[0].length - 1]

    until queue.empty?
      current_position = queue.pop
      next if visited_positions.include?(current_position)
      visited_positions.add(current_position)

      if current_position[0..1] == factory_position && (!part2 || current_position[2] > 3)
        factory_position = current_position
        break
      end

      generate_neighbors(current_position, part2:).each do |neighbor_position, heat_loss|
        next if visited_positions.include?(neighbor_position)
        updated_heat_loss = heat_loss_to_position[current_position] + heat_loss
        if !heat_loss_to_position.key?(neighbor_position) || updated_heat_loss < heat_loss_to_position[neighbor_position]
          heat_loss_to_position[neighbor_position] = updated_heat_loss
          queue.push(neighbor_position)
        end
      end
    end

    heat_loss_to_position[factory_position]
  end

  def generate_neighbors(position, part2: false)
    x, y, consecutive_straight_moves, current_direction = position
    dx, dy = current_direction
    grid_height = heat_loss_grid.length
    grid_width = heat_loss_grid[0].length
    neighbors = []

    new_x, new_y = x + dx, y + dy
    if consecutive_straight_moves < (part2 ? 10 : 3) &&
        new_x.between?(0, grid_height - 1) && new_y.between?(0, grid_width - 1)
      neighbors << [[new_x, new_y, consecutive_straight_moves + 1, current_direction],
        heat_loss_grid[new_x][new_y]]
    end

    [[-dy, dx], [dy, -dx]].each do |turn_dx, turn_dy|
      new_x, new_y = x + turn_dx, y + turn_dy
      if new_x.between?(0, grid_height - 1) && new_y.between?(0, grid_width - 1) &&
          (!part2 || consecutive_straight_moves > 3)
        neighbors << [[new_x, new_y, 1, [turn_dx, turn_dy]],
          heat_loss_grid[new_x][new_y]]
      end
    end

    neighbors
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution17.new
  solution.run
end
