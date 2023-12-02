require_relative "../../lib/base"

class AoC::Year2022::Solution02 < Base
  def part1
    score_map = {"X" => 1, "Y" => 2, "Z" => 3}
    win_conditions = {["A", "Y"] => true, ["B", "Z"] => true, ["C", "X"] => true}
    draw_conditions = {["A", "X"] => true, ["B", "Y"] => true, ["C", "Z"] => true}

    input.each_line.sum do |line|
      opponent_choice, our_choice = line.split
      our_score = score_map[our_choice]

      if draw_conditions[[opponent_choice, our_choice]]
        our_score + 3 # draw
      elsif win_conditions[[opponent_choice, our_choice]]
        our_score + 6 # win
      else
        our_score # lose
      end
    end
  end

  def part2
    desired_outcome_to_move = {
      ["A", "X"] => "C",
      ["A", "Y"] => "A",
      ["A", "Z"] => "B",
      ["B", "X"] => "A",
      ["B", "Y"] => "B",
      ["B", "Z"] => "C",
      ["C", "X"] => "B",
      ["C", "Y"] => "C",
      ["C", "Z"] => "A"
    }

    score_map = {"A" => 1, "B" => 2, "C" => 3}

    input_lines.sum do |line|
      opponent_choice, desired_outcome = line.split
      our_choice = desired_outcome_to_move[[opponent_choice, desired_outcome]]
      our_score = score_map[our_choice]

      case desired_outcome
      when "X"
        our_score
      when "Y"
        our_score + 3
      when "Z"
        our_score + 6
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2022::Solution02.new
  solution.run
end
