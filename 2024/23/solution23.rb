require_relative "../../lib/base"

# Solution for the 2024 day 23 puzzle
# https://adventofcode.com/2024/day/23
class AoC::Year2024::Solution23 < Base
  def part1
    triples = connections.keys.flat_map do |node|
      connections[node].flat_map do |mid|
        (connections[node] & connections[mid]).map do |last|
          [node, mid, last].sort
        end
      end
    end.uniq

    triples.count { |triple| triple.any? { _1.start_with?("t") } }
  end

  def part2
    connections.keys
      .map { find_max_clique(_1) }
      .max_by(&:size)
      .sort
      .join(",")
  end

  private

  def connections
    @connections ||= input_lines.each_with_object(Hash.new { |h, k| h[k] = Set.new }) do |line, conn|
      a, b = line.split("-")
      conn[a] << b
      conn[b] << a
    end
  end

  def find_max_clique(start)
    possible = [start, *connections[start]]

    possible.size.downto(1) do |size|
      possible.combination(size) do |nodes|
        return nodes if nodes.all? { |n1| (nodes - [n1]).all? { connections[n1].include?(_1) } }
      end
    end

    [start]
  end
end
