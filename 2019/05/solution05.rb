require_relative "../../lib/base"

# Solution for the 2019 day 5 puzzle
# https://adventofcode.com/2019/day/5
module AoC::Year2019
  class Solution05 < Base
    def part1
      run_with_input(1).last
    end

    def part2
      run_with_input(5).last
    end

    def run_with_input(input)
      program = input_lines.first.split(",").map(&:to_i)
      machine = IntcodeComputer.new(program, input)
      machine.run
    end
  end

  class IntcodeComputer
    attr_accessor :program, :pointer, :input, :output

    def initialize(program, input)
      @program = program.dup
      @pointer = 0
      @input = input
      @output = []
    end

    def run
      catch :halt do
        loop do
          instruction = @program[@pointer]
          opcode = instruction % 100
          modes = (instruction / 100).digits
          modes << 0 while modes.length < 3

          send(:"opcode_#{opcode}", modes)
        end
      end
      @output
    end

    private

    def get_value(mode, index) = (mode == 0) ? @program[@program[index]] : @program[index]

    def opcode_1(modes) = perform_binary_operation(modes, &:+)

    def opcode_2(modes) = perform_binary_operation(modes, &:*)

    def opcode_3(_modes)
      target = @program[@pointer + 1]
      @program[target] = @input
      @pointer += 2
    end

    def opcode_4(modes)
      @output << get_value(modes[0], @pointer + 1)
      @pointer += 2
    end

    def opcode_5(modes) = jump_if(modes) { _1 != 0 }

    def opcode_6(modes) = jump_if(modes) { _1 == 0 }

    def opcode_7(modes) = compare_and_set(modes, &:<)

    def opcode_8(modes) = compare_and_set(modes, &:==)

    def opcode_99(_modes) = throw :halt

    def perform_binary_operation(modes)
      val1 = get_value(modes[0], @pointer + 1)
      val2 = get_value(modes[1], @pointer + 2)
      target = @program[@pointer + 3]
      @program[target] = yield(val1, val2)
      @pointer += 4
    end

    def jump_if(modes)
      val1 = get_value(modes[0], @pointer + 1)
      val2 = get_value(modes[1], @pointer + 2)
      @pointer = yield(val1) ? val2 : @pointer + 3
    end

    def compare_and_set(modes)
      val1 = get_value(modes[0], @pointer + 1)
      val2 = get_value(modes[1], @pointer + 2)
      target = @program[@pointer + 3]
      @program[target] = yield(val1, val2) ? 1 : 0
      @pointer += 4
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2019::Solution05.new
  solution.run
end
