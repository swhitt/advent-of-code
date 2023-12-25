require_relative "../../lib/base"

# Solution for the 2023 day 1 puzzle
# https://adventofcode.com/2023/day/1
class AoC::Year2023::Solution01 < Base
  NUMBER_WORDS_TO_DIGITS = {
    "zero" => "0", "one" => "1", "two" => "2", "three" => "3", "four" => "4",
    "five" => "5", "six" => "6", "seven" => "7", "eight" => "8", "nine" => "9"
  }.freeze

  def part1
    input_lines.map do |line|
      first_digit, last_digit = line.scan(/\d/).values_at(0, -1)
      "#{first_digit}#{last_digit}".to_i
    end.sum
  end

  def part2
    input_lines.map do |line|
      nums = extract_numbers(line)
      first_digit, last_digit = nums.values_at(0, -1)
      "#{first_digit}#{last_digit}".to_i
    end.sum
  end

  def extract_numbers(line)
    words_pattern = Regexp.union(NUMBER_WORDS_TO_DIGITS.keys)
    pattern = /(?=(#{words_pattern}|\d))/
    line.scan(pattern).flatten.map do |match|
      if /\d/.match?(match)
        match
      else
        NUMBER_WORDS_TO_DIGITS[match]
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution01.new
  solution.run
end
