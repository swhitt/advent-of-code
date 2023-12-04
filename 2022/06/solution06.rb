require_relative "../../lib/base"

class AoC::Year2022::Solution06 < Base
  def part1
    find_start_of_n_unique_chars(4)
  end

  def part2
    find_start_of_n_unique_chars(14)
  end

  def find_start_of_n_unique_chars(n)
    input.chars.each_cons(n).with_index do |chars, i|
      return i + n if chars.uniq.size == n
    end
    input.size + 1
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2022::Solution06.new
  solution.run
end
