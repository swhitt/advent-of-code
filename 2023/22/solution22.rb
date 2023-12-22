require_relative "../../lib/base"

# Solution for the 2023 day 22 puzzle
# https://adventofcode.com/2023/day/22
class AoC::Year2023::Solution22 < Base
  def initialize(...)
    super
    @bricks = parse_input
    @settled_bricks = Set.new
    @resting_positions = {}
    @block_supported_by = {}
    @num_blocks = @bricks.length
    process_blocks
  end

  def part1
    @num_blocks - single_supported_blocks.length
  end

  def part2
    calculate_collapses
  end

  private

  def parse_input
    input_lines.map do |line|
      coords = line.strip.split("~").flat_map { _1.split(",").map(&:to_i) }
      [coords[0..2], coords[3..5]]
    end.sort_by { [_1.rotate(-1), _2.rotate(-1)] }
  end

  def process_blocks
    @bricks.each_with_index do |(block_start, block_end), n|
      @block_supported_by[n] = Set.new
      current_block_set = create_block_set(block_start, block_end)
      @resting_positions[n] = Set.new

      until current_block_set.any? { |_, _, z| z == 0 }
        new_block_set = current_block_set.map { |x, y, z| [x, y, z - 1] }.to_set
        check_set = new_block_set & @settled_bricks
        break if check_set.any?
        current_block_set = new_block_set
      end

      current_block_set.each do |block|
        @settled_bricks.add(block)
        @resting_positions[n].add(block)
      end
      (0...n).each do |t|
        new_check = check_set & @resting_positions[t]
        @block_supported_by[n].add(t) unless new_check.empty?
      end
    end
  end

  def create_block_set(block_start, block_end)
    (ax, ay, az), (bx, by, bz) = block_start, block_end
    Set.new.tap do |block_set|
      if az != bz
        (az..bz).each { |z| block_set.add([ax, ay, z]) }
      elsif ax != bx
        (ax..bx).each { |x| block_set.add([x, ay, az]) }
      elsif ay != by
        (ay..by).each { |y| block_set.add([ax, y, az]) }
      else
        block_set.add([ax, ay, az])
      end
    end
  end

  def single_supported_blocks
    @block_supported_by.values.select(&:one?).map(&:first).to_set
  end

  def calculate_collapses
    (0...@num_blocks).inject(0) do |total_falling_bricks, t|
      falling_set = [t].to_set
      loop do
        falling = false
        (t + 1...@num_blocks).each do |n|
          next if falling_set.include?(n)
          block_supported_by_set = @block_supported_by[n].dup
          next if block_supported_by_set.empty?
          check_set = block_supported_by_set - falling_set
          if check_set.empty?
            falling_set << n
            falling = true
          end
        end
        break unless falling
      end
      total_falling_bricks + falling_set.size - 1
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution22.new
  solution.run
end
