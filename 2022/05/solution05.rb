require_relative "../../lib/base"

class AoC::Year2022::Solution05 < Base
  def part1
    # do it first
  end

  def part2
    # do it second
  end

  def stacks
    lines = stack_definition.lines.map(&:chomp)
    chars = lines.map(&:chars).transpose

    chars.each_with_object({}) do |stack, hash|
      next if stack.none? { |c| c.match?(/\d+/) }

      key = stack.pop
      hash[key] = stack.reject { |e| e == " " }
    end
  end

  def moves
    move_definition.split("\n").map do |line|
      if (match = line.match(/^move (\d+) from (\d+) to (\d+)$/))
        count, from_stack, to_stack = match.captures.map(&:to_i)
        {from: from_stack, to: to_stack, count: count}
      end
    end.compact
  end

  def stack_definition
    input.split("\n\n")[0]
  end

  def move_definition
    input.split("\n\n")[1]
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2022::Solution05.new
  solution.run
end
