require "pqueue"
require "marshal"

module Util
  def chunk_array(array, chunk_size)
    array.each_slice(chunk_size).to_a
  end

  def grid_neighbors(grid, row, col, diagonals: false)
    directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    directions += [[-1, -1], [-1, 1], [1, -1], [1, 1]] if diagonals
    directions.filter_map do |dx, dy|
      [row + dx, col + dy] if (0...grid.size).cover?(row + dx) && (0...grid.first.size).cover?(col + dy)
    end
  end

  def string_to_digits(str)
    str.chars.map(&:to_i)
  end

  def binary_to_int(binary_str)
    Integer(binary_str, 2)
  end

  def frequency(array)
    array.each_with_object(Hash.new(0)) { |item, counts| counts[item] += 1 }
  end

  def gcd(a, b)
    b.zero? ? a : gcd(b, a % b)
  end

  def lcm(a, b)
    a * b / gcd(a, b)
  end

  def deep_copy(obj)
    Marshal.load(Marshal.dump(obj))
  end

  def manhattan_distance(x1, y1, x2, y2)
    (x1 - x2).abs + (y1 - y2).abs
  end

  def priority_queue(&block)
    PQueue.new(&block)
  end
end
