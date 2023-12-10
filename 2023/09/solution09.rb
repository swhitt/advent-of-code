require_relative "../../lib/base"

class AoC::Year2023::Solution09 < Base
  def part1
    parsed_histories.sum { |history| predict_next(history) }
  end

  def part2
    parsed_histories.sum { |history| predict_next(history.reverse) }
  end

  def parsed_histories
    @parsed_histories ||= input_lines.map { |line| line.split.map(&:to_i) }
  end

  def generate_difference_sequences(sequence)
    sequences = [sequence]
    while sequences.last.any?(&:nonzero?)
      sequences << sequences.last.each_cons(2).map { |a, b| b - a }
    end
    sequences
  end

  def predict_next(history)
    sequences = generate_difference_sequences(history)
    next_value = sequences.first.last
    sequences.reverse_each { |seq| next_value += seq.last if seq.length != sequences.first.length }
    next_value
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution09.new
  solution.run
end
