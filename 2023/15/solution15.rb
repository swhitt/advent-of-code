require_relative "../../lib/base"

# Solution for the 2023 day 15 puzzle
# https://adventofcode.com/2023/day/15
class AoC::Year2023::Solution15 < Base
  def part1
    steps.sum { calculate_hash(_1) }
  end

  def part2
    boxes = Array.new(256) { [] }
    steps.each { process_step(_1, boxes) }
    calculate_focusing_power(boxes)
  end

  def calculate_hash(string)
    string.chars.reduce(0) { |acc, char| (acc + char.ord) * 17 % 256 }
  end

  def process_step(step, boxes)
    label = step[/[a-z]+/]
    box_index = calculate_hash(label)
    case step[label.length]
    when "-"
      boxes[box_index].reject! { |lens| lens[:label] == label }
    when "="
      focal_length = step[/\d+$/].to_i
      lens = boxes[box_index].find { |l| l[:label] == label }
      lens ? lens[:focal_length] = focal_length : boxes[box_index] << {label: label, focal_length: focal_length}
    end
  end

  def calculate_focusing_power(boxes)
    boxes.each_with_index.sum do |box, box_index|
      box.each_with_index.sum do |lens, slot_index|
        (box_index + 1) * (slot_index + 1) * lens[:focal_length]
      end
    end
  end

  def steps
    @steps ||= input.strip.split(",")
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution15.new
  solution.run
end
