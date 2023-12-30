require_relative "../../lib/base"

# Solution for the 2023 day 23 puzzle
# https://adventofcode.com/2023/day/23
class AoC::Year2023::Solution23 < Base
  def part1
    graph.find_longest_path[1]
  end

  def part2
    graph.find_longest_path(enforce_slopes: false)[1]
  end

  def graph
    @graph ||= GridGraph.new(input_lines: input_lines)
  end
end

module GridUtils
  ADJACENT_DELTAS = {
    "." => [[1, 0], [-1, 0], [0, 1], [0, -1]],
    ">" => [[0, 1]],
    "<" => [[0, -1]],
    "^" => [[-1, 0]],
    "v" => [[1, 0]]
  }.freeze
  def grid_from_input_lines(input_lines)
    input_lines.each.with_index.with_object({}) do |(row, i), grid|
      row.chars.each.with_index { |cell, j| grid[[i, j]] = cell if cell != "#" }
    end
  end

  def create_graph(grid, enforce_slopes: true)
    grid.keys.each_with_object({}) do |pos, edges|
      cell_type = grid[pos]
      deltas = enforce_slopes ? ADJACENT_DELTAS[cell_type] : ADJACENT_DELTAS["."]

      edges[pos] =
        deltas
          .map { [[pos[0] + _1, pos[1] + _2], 1] }
          .select { |pos, dist| grid.key?(pos) }
    end
  end

  def collapse(original_graph, grid, check_slopes: true)
    Marshal.load(Marshal.dump(original_graph)).tap do |graph|
      while (nodes_to_collapse = graph.select { |node, edges| collapsible_node?(node, edges, grid, check_slopes:) }.keys).any?
        nodes_to_collapse.each do |node|
          collapse_node(graph, node)
        end
      end
    end
  end

  def collapsible_node?(node, edges, grid, check_slopes: true)
    return false unless edges.length == 2
    return true if !check_slopes
    return false unless grid[node] == "."
    edges.all? { |(neighbor, _)| grid[neighbor] == "." }
  end

  def collapse_node(graph, node)
    return unless graph[node].length == 2
    neighbor1, dist1 = graph[node][0]
    neighbor2, dist2 = graph[node][1]

    graph.delete(node)

    [neighbor1, neighbor2].each do |neighbor|
      graph[neighbor].each do |edge|
        next if edge[0] != node
        edge[0] = (neighbor == neighbor1) ? neighbor2 : neighbor1
        edge[1] += (neighbor == neighbor1) ? dist2 : dist1
      end
    end
  end

  def search(graph, start, stop)
    seen = Set.new
    best_path_info = {path: [], distance: 0}

    search_recursive(graph, start, [], 0, best_path_info, stop, seen)

    best_path_info.values_at(:path, :distance)
  end

  private

  def search_recursive(graph, node, path, dist, best_path_info, stop, seen)
    if node == stop && dist > best_path_info[:distance]
      best_path_info[:path] = path + [node]
      best_path_info[:distance] = dist
      return
    end
    return if seen.include?(node)

    seen.add(node)
    graph[node].each do |(next_node, next_dist)|
      search_recursive(graph, next_node, path + [node], dist + next_dist, best_path_info, stop, seen)
    end
    seen.delete(node)
  end
end

class GridGraph
  include GridUtils
  attr_accessor :debug
  attr_reader :input_lines

  def initialize(input_lines:, debug: ENV["TEST"] != "true")
    @input_lines = input_lines
    @debug = debug
  end

  def find_longest_path(enforce_slopes: true)
    puts_debug "Finding longest path (enforce_slopes: #{enforce_slopes})"
    graph = create_graph(grid, enforce_slopes:)
    puts_debug "  Graph created (#{graph.length} nodes)"
    graph = collapse(graph, grid, check_slopes: enforce_slopes)
    puts_debug "  Graph collapsed (#{graph.length} nodes remaining)"
    start = grid.keys.first
    stop = grid.keys.last
    puts_debug "  Searching for longest path from #{start} to #{stop}"
    search(graph, start, stop)
  end

  def grid
    @grid ||= grid_from_input_lines(input_lines)
  end

  def puts_debug(message)
    puts message if @debug
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution23.new
  solution.run
end
