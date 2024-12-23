require_relative "../../lib/base"

# Solution for the 2024 day 23 puzzle
# https://adventofcode.com/2024/day/23
class AoC::Year2024::Solution23 < Base
  def part1
    triples = Set.new

    connections.each_key do |node|
      connections[node].each do |mid|
        others = connections[node] - [mid]
        next unless others.any? { connections[mid].include?(_1) }

        others.each do |last|
          triples << [node, mid, last].sort if connections[mid].include?(last)
        end
      end
    end

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
    @connections ||= input_lines.each_with_object(Hash.new { |h, k| h[k] = [] }) do |line, conn|
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
