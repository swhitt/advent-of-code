require_relative "../../lib/base"

# Solution for the 2023 day 19 puzzle
# https://adventofcode.com/2023/day/19
class AoC::Year2023::Solution19 < Base
  attr_reader :workflow, :parts

  def initialize(...)
    super
    workflow_str, raw_parts = input.strip.split("\n\n")
    @parts = parse_parts(raw_parts)
    @workflow = process_workflow(workflow_str)
  end

  def part1
    parts.sum { evaluate_workflow_for_part(_1, "in") ? _1.sum : 0 }
  end

  def part2
    process_rule("in", [], [], process_rules(workflow))
  end

  private

  def parse_parts(raw_parts)
    raw_parts.lines.map { _1.scan(/\d+/).map(&:to_i) }
  end

  def process_workflow(workflow_str)
    workflow_str.lines.each_with_object({}) do |line, workflow_hash|
      key, value = line.split("{", 2).map(&:strip)
      workflow_hash[key.strip] = value.chomp("}") if key && value
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
      next unless evaluate_condition(condition, x, m, a, s)

      return false if action == "R"
      return true if action == "A"
      return evaluate_workflow_for_part(part, action)
    end

    raise "Invalid workflow step: #{workflow_step}"
  end

  def evaluate_condition(cond, x, m, a, s)
    instance_eval(cond.gsub(/[xmas]/, "x" => x.to_s, "m" => m.to_s, "a" => a.to_s, "s" => s.to_s))
  end

  def process_rules(workflow_hash)
    processed_rules = {}
    workflow_hash.each do |name, rule_str|
      matches = rule_str.split(",").map(&:strip)
      processed_rules[name] = matches.map do |match|
        if match.include?(":")
          parts = match.split(":").map(&:strip)
          [parts[0], parts[1]]
        else
          ["True", match]
        end
      end
    end
    processed_rules
  end

  def process_criteria(criteria)
    vals = {
      "x" => [0] + [1] * 4000,
      "m" => [0] + [1] * 4000,
      "a" => [0] + [1] * 4000,
      "s" => [0] + [1] * 4000
    }

    criteria.each do |criterion|
      next if criterion == "True"

      negate = criterion.start_with?("!")
      criterion = criterion[1..] if negate
      var, comp, limit = criterion[0], criterion[1], criterion[2..].to_i

      range = case comp
      when "<"
        negate ? (1...limit) : (limit..4000)
      else
        negate ? (limit + 1..4000) : (1...limit + 1)
      end

      vals[var][range] = Array.new(range.size, 0)
    end

    vals.values.map(&:sum).reduce(:*)
  end

  def process_rule(name, previous_crit, previous_rules, rules)
    total = 0
    inverted_criteria = []
    rules[name].each do |criteria, rule|
      if rule == "A"
        total += process_criteria(previous_crit + inverted_criteria + [criteria])
      elsif rule != "R"
        total += process_rule(rule, previous_crit + inverted_criteria + [criteria], previous_rules + [name], rules)
      end
      inverted_criteria << "!" + criteria
    end
    total
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution19.new
  solution.run
end
