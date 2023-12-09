require_relative "../../lib/base"

class AoC::Year2020::Solution02 < Base
  def part1
    validate_passwords do |min, max, letter, password|
      password.count(letter).between?(min, max)
    end
  end

  def part2
    validate_passwords do |pos1, pos2, letter, password|
      # policy positions are 1-indexed
      (password[pos1 - 1] == letter) ^ (password[pos2 - 1] == letter)
    end
  end

  def validate_passwords
    input_lines.inject(0) do |valid_count, line|
      policy, password = line.split(": ")
      numbers, letter = policy.split(" ")
      num1, num2 = numbers.split("-").map(&:to_i)

      valid_count + (yield(num1, num2, letter, password) ? 1 : 0)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2020::Solution02.new
  solution.run
end
