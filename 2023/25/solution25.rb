require_relative "../../lib/base"

# Solution for the 2023 day 25 puzzle
# https://adventofcode.com/2023/day/25
class AoC::Year2023::Solution25 < Base
  def part1
    parse_input
    @graph.find_min_cut.inject(:*)
  end

  def parse_input
    @graph = Graph.new
    input_lines.each do |line|
      node, edges = line.strip.split(":")
      next unless edges
      edges.strip.split(" ").each { @graph.add_edge(node.strip, _1.strip) }
    end
  end

  def part2
      "We saved Christmas"
  end
end

class Graph
  attr_accessor :vertices

  def initialize
    @vertices = Hash.new { |h, k| h[k] = [] }
  end

  def add_edge(node1, node2)
    @vertices[node1] << node2
    @vertices[node2] << node1
  end

  def merge_vertices(node1, node2)
    @vertices[node1].concat(@vertices[node2])
    @vertices[node2].each do |vertex|
      @vertices[vertex].map! { (_1 == node2) ? node1 : _1 }
    end
    @vertices[node1].reject! { _1 == node1 }
    @vertices.delete(node2)
  end

  def get_random_edge
    node = @vertices.keys.sample
    [node, @vertices[node].sample]
  end

  def karger_min_cut_and_subgraphs
    # https://www.geeksforgeeks.org/introduction-and-implementation-of-kargers-algorithm-for-minimum-cut/
    merged_vertices = Hash.new { |h, k| h[k] = [k] }

    while @vertices.length > 2
      node1, node2 = get_random_edge
      merge_vertices(node1, node2)
      merged_vertices[node1] += merged_vertices[node2]
      merged_vertices.delete(node2)
    end

    min_cut_size = @vertices.values.first.size
    subgraph_sizes = merged_vertices.values.map(&:size)

    [min_cut_size, subgraph_sizes]
  end

  def marshal_dump
    Hash[@vertices] # rubocop:disable Style/HashConversion
  end

  def marshal_load(hash)
    @vertices = Hash.new { |h, k| h[k] = [] }
    hash.each { |k, v| @vertices[k] = v }
  end

  def find_min_cut(known_min_cut_size = 3)
    min_cut = Float::INFINITY
    subgraph_sizes = []
    iterations = (@vertices.length**2 * Math.log(@vertices.length)).to_i

    iterations.times do
      temp_graph = Marshal.load(Marshal.dump(self))
      current_min_cut, current_subgraph_sizes = temp_graph.karger_min_cut_and_subgraphs
      if current_min_cut < min_cut
        min_cut = current_min_cut
        subgraph_sizes = current_subgraph_sizes
      end
      break if min_cut == known_min_cut_size
    end

    subgraph_sizes
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution25.new
  solution.run
end
