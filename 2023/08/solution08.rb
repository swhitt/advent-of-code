require_relative "../../lib/base"

# Solution for the 2023 day 8 puzzle
# https://adventofcode.com/2023/day/8
module AoC
  module Year2023
    class Navigator
      attr_reader :directions, :connections

      def initialize(input_lines)
        @directions, @connections = parse_input(input_lines)
      end

      def parse_input(input_lines)
        directions = input_lines.first
        connections = input_lines.drop(2).each_with_object({}) do |line, hash|
          node, next_nodes = line.split(" = ")
          hash[node] = next_nodes.tr("()", "").split(", ")
        end

        [directions, connections]
      end

      def navigate_single
        navigate(directions)
      end

      def navigate(directions, current_node: "AAA")
        directions.chars.cycle.each.with_index(1).find do |instruction, index|
          current_node = connections[current_node][direction_index(instruction)]
          current_node == "ZZZ" && (return index)
        end
      end

      def navigate_ghosts
        starting_positions = connections.keys.select { |key| key.end_with?("A") }
        navigate_with_ghosts(directions, starting_positions)
      end

      def navigate_with_ghosts(directions, current_positions)
        steps_to_ends = {}
        step = 0

        until steps_to_ends.size == current_positions.size
          idx = direction_index((directions[step % directions.length]))
          current_positions.map! { |current| connections[current][idx] }

          current_positions.each_with_index do |position, idx|
            steps_to_ends[idx] ||= step + 1 if position.end_with?("Z")
          end

          step += 1
        end
        steps_to_ends.values.reduce(:lcm)
      end

      def direction_index(instruction)
        {"L" => 0, "R" => 1}.fetch(instruction) { raise "Invalid instruction: #{instruction}" }
      end
    end

    class Solution08 < Base
      def part1
        Navigator.new(input_lines).navigate_single
      end

      def part2
        Navigator.new(input_lines).navigate_ghosts
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution08.new
  solution.run
end
