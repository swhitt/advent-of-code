require_relative "../../lib/base"

class AoC::Year2023::Solution09 < Base
  def part1
    parsed_histories.sum { |history| predict_value(history, :next) }
  end

  def part2
    parsed_histories.sum { |history| predict_value(history, :previous) }
  end

  def parsed_histories
    @parsed_histories ||= input_lines.map { |line| line.split.map(&:to_i) }
  end

  def predict_value(history, direction)
    sequences = generate_difference_sequences(history)
    (direction == :next) ? predict_next(sequences) : predict_previous(sequences)
  end

  def generate_difference_sequences(sequence)
    sequences = [sequence]
    while sequences.last.any?(&:nonzero?)
      sequences << sequences.last.each_cons(2).map { |a, b| b - a }
    end
    sequences
  end

  def predict_next(sequences)
    next_value = sequences.first.last
    sequences.reverse_each { |seq| next_value += seq.last if seq.length != sequences.first.length }
    next_value
  end

  def predict_previous(sequences)
    difference_sequences = sequences
    difference_sequences.last.unshift(0)

    (difference_sequences.size - 2).downto(0) do |i|
      difference_sequences[i].unshift(difference_sequences[i].first - difference_sequences[i + 1].first)
    end

    difference_sequences.first.first
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution09.new
  solution.run
end
