require_relative "../../lib/base"

class AoC::Year2023::Solution06 < Base
  def part1
    times, distances = input_lines.map { |line| line.scan(/\d+/).map(&:to_i) }
    calculate_ways_to_win(times.zip(distances))
  end

  def part2
    input_time, input_distance = input_lines.map { |line| line.gsub(/[^\d]/, "").to_i }
    calculate_ways_to_win([[input_time, input_distance]])
  end

  private

  def calculate_ways_to_win(races)
    races.inject(1) { |product, (time, record)| product * calculate_ways(time, record) }
  end

  def calculate_ways(time, record_distance)
    (1...time).count { |hold_duration| (time - hold_duration) * hold_duration > record_distance }
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution06.new
  solution.run
end
