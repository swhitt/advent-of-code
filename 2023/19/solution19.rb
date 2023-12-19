require_relative "../../lib/base"

# Solution for the 2023 day 19 puzzle
# https://adventofcode.com/2023/day/19
class AoC::Year2023::Solution19 < Base
  attr_reader :workflow, :parts

  def initialize
    super
    workflow_str, raw_parts = input.strip.split("\n\n")
    @parts = parse_parts(raw_parts)
    @workflow = process_workflow(workflow_str)
  end

  def part1
    parts.sum { evaluate_workflow_for_part(_1, "in") ? _1.sum : 0 }
  end

  def part2
    # not yet done
  end

  private

  def parse_parts(raw_parts)
    raw_parts.split("\n").map { |line| line.scan(/\d+/).map(&:to_i) }
  end

  def process_workflow(workflow_str)
    workflow_str.split("\n").each_with_object({}) do |line, workflow_hash|
      key, value = line.split("{", 2)
      next if key.nil? || value.nil?

      workflow_hash[key.strip] = value.chomp("}").strip
    end
  end

  def evaluate_workflow_for_part(part, workflow_step)
    current_workflow = workflow[workflow_step]
    x, m, a, s = part

    current_workflow.split(",").each do |step|
      return false if step == "R"
      return true if step == "A"
      return evaluate_workflow_for_part(part, step) unless step.include?(":")

      condition, action = step.split(":")
      if evaluate_condition(condition, x, m, a, s)
        return false if action == "R"
        return true if action == "A"
        return evaluate_workflow_for_part(part, action)
      end
    end
    raise "Invalid workflow step: #{current_workflow}"
  end

  def evaluate_condition(cond, x, m, a, s)
    cond.gsub("x", x.to_s)
      .gsub("m", m.to_s)
      .gsub("a", a.to_s)
      .gsub("s", s.to_s).yield_self { instance_eval(_1) }
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution19.new
  solution.run
end
