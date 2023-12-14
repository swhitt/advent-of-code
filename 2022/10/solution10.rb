require_relative "../../lib/base"

# Solution for the 2022 day 10 puzzle
# https://adventofcode.com/2022/day/10
class AoC::Year2022::Solution10 < Base
  def part1
    execute.output_signal
  end

  def part2
    execute.crt
  end

  def execute
    CPU.process(input_lines)
  end
  memoize(:execute)
end

class CPU
  DISPLAY_WIDTH = 40
  DISPLAY_HEIGHT = 6

  attr_accessor :output_signal, :crt

  def initialize
    @cycles = 0
    @x = 1
    @output_signal = 0
    @crt = Array.new(DISPLAY_HEIGHT) { "." * DISPLAY_WIDTH }
  end

  def self.process(commands)
    new.tap { _1.process(commands) }
  end

  def process(commands)
    commands.each { interpret(_1) }
  end

  def interpret(command)
    operation, value = command.split(" ")

    case operation
    when "noop"
      perform_cycle
    when "addx"
      perform_cycle(num_times: 2)
      @x += value.to_i
    end
  end

  def perform_cycle(num_times: 1)
    num_times.times do
      @cycles += 1
      update_display

      if @cycles % 40 == 20
        @output_signal += @cycles * @x
      end
    end
  end

  def update_display
    @crt[current_row][current_col] = "#" if (@x - current_col).abs <= 1
  end

  def current_index
    (@cycles - 1) % (DISPLAY_HEIGHT * DISPLAY_WIDTH)
  end

  def current_col
    current_index % DISPLAY_WIDTH
  end

  def current_row
    current_index / DISPLAY_WIDTH
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2022::Solution10.new
  solution.run
end
