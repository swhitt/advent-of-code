# frozen_string_literal: true

require_relative "../../lib/base"

class AoC::Year2022::Solution01 < Base
  def part1
    elf_inventories = input.split("\n\n")
    elf_inventories.map do |inventory|
      inventory.split.map(&:to_i).sum
    end.max
  end

  def part2
    elf_inventories = input.split("\n\n")
    calorie_totals = elf_inventories.map do |inventory|
      inventory.split.map(&:to_i).sum
    end
    top_three_totals = calorie_totals.sort.reverse.take(3)
    top_three_totals.sum
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2022::Solution01.new
  solution.run
end
