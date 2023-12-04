require_relative "../../lib/base"

class AoC::Year2022::Solution05 < Base
  def part1
    crane do |from_stack, to_stack, count|
      count.times do
        box = from_stack.shift
        to_stack.unshift(box)
      end
    end.values.map(&:first).join
  end

  def part2
    crane do |from_stack, to_stack, count|
      boxes = from_stack.shift(count)
      to_stack.unshift(*boxes)
    end.values.map(&:first).join
  end

  def crane
    stacks = initial_stacks
    moves.each do |move|
      from_stack = stacks[move[:from]]
      to_stack = stacks[move[:to]]
      count = move[:count]
      yield(from_stack, to_stack, count) if block_given?
    end
    stacks
  end

  def initial_stacks
    lines = stack_definition.lines.map(&:chomp)
    chars = lines.map(&:chars).transpose

    chars.each_with_object({}) do |stack, hash|
      next if stack.none? { |c| c.match?(/\d+/) }

      key = stack.pop
      hash[key.to_i] = stack.reject { |e| e == " " }
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
