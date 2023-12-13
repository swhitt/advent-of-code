require_relative "../../lib/base"

class AoC::Year2023::Solution05 < Base
  def part1
    # reworked to use the same map_ranges used by part 2
    final_ranges(seeds.map { |x| [x, 1] }).min_by(&:first).first
  end

  def part2
    final_ranges(seed_ranges).min_by(&:first).first
  end

  def final_ranges(first_ranges, map_set = nil)
    map_set = maps if map_set.nil?
    first_ranges.flat_map do |(start, length)|
      map_set.reduce([[start, length]]) do |ranges, rules|
        ranges.flat_map { |range| map_ranges(range, rules) }
      end
    end
  end

  def maps
    input_sections[1..].map { |section| section.lines[1..].map { |line| line.split.map(&:to_i) } }
  end

  def input_sections
    input.split("\n\n")
  end

  def seed_ranges
    seeds.each_slice(2).to_a
  end

  def seeds
    input_sections[0].gsub("seeds: ", "").split.map(&:to_i)
  end

  def map_ranges(source_range, rules)
    src_start, src_length = source_range
    src_end = src_start + src_length - 1
    output_ranges = []
    current_pos = src_start

    sorted_rules = rules.sort_by { |_, rule_src_start, _| rule_src_start }

    sorted_rules.each do |dest_start, rule_src_start, rule_length|
      rule_src_end = rule_src_start + rule_length - 1
      break if current_pos > src_end

      if rule_src_start > current_pos
        gap_end = [rule_src_start - 1, src_end].min
        output_ranges << [current_pos, gap_end - current_pos + 1] if gap_end >= current_pos
        current_pos = rule_src_start
      end

      overlap_end = [rule_src_end, src_end].min + 0
      if current_pos <= overlap_end
        dest_overlap_start = dest_start + (current_pos - rule_src_start)
        output_ranges << [dest_overlap_start, overlap_end - current_pos + 1]
        current_pos = rule_src_end + 1
      end
    end

    if current_pos <= src_end
      output_ranges << [current_pos, src_end - current_pos + 1]
    end

    output_ranges
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution05.new
  solution.run
end
