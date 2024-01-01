require_relative "../../lib/base"

# Solution for the 2019 day 2 puzzle
# https://adventofcode.com/2019/day/2
class AoC::Year2019::Solution02 < Base
  OPCODES = {
    1 => {params: 3, operation: ->(a, b, c, program) { program[c] = program[a] + program[b] }},
    2 => {params: 3, operation: ->(a, b, c, program) { program[c] = program[a] * program[b] }},
    99 => {params: 0, operation: ->(*) { throw :halt }}
  }.freeze

  def part1(input: nil)
    process_program(noun: 12, verb: 2, input: input).first
  end

  def part2(to_find: 19_690_720, input: nil)
    (0..99).to_a.repeated_permutation(2).find do |noun, verb|
      process_program(noun: noun, verb: verb, input: input).first == to_find
    end.then { |noun, verb| 100 * noun + verb }
  end

  def process_program(noun: nil, verb: nil, input: nil)
    program = (input || input_lines.first).split(",").map(&:to_i)
    program[1] = noun if noun
    program[2] = verb if verb
    run_intcode(program)
  end

  def run_intcode(program)
    pointer = 0

    catch :halt do
      while pointer < program.size
        opcode = program[pointer]
        opcode_info = OPCODES[opcode] || raise("Unknown opcode: #{opcode}")
        params = program[pointer + 1, opcode_info[:params]]
        operation = opcode_info[:operation]
        operation.call(*params, program)
        pointer += opcode_info[:params] + 1
      end
    end

    program
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2019::Solution02.new
  solution.run
end
