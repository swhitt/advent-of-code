require "pqueue"

module Util
  def self.chunk_array(array, chunk_size)
    array.each_slice(chunk_size).to_a
  end

  def self.grid_neighbors(grid, row, col, diagonals: false)
    directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    directions += [[-1, -1], [-1, 1], [1, -1], [1, 1]] if diagonals
    directions.filter_map do |dx, dy|
      [row + dx, col + dy] if (0...grid.size).cover?(row + dx) && (0...grid.first.size).cover?(col + dy)
    end
  end

  def self.print_grid(grid, delimiter = " ")
    grid.tap { |g| g.each { |row| puts row.join(delimiter) } }
  end

  def self.subgrid(grid, top_left, bottom_right)
    top_row, left_col = top_left
    bottom_row, right_col = bottom_right

    grid.slice(top_row..bottom_row).map do |row|
      row.slice(left_col..right_col)
    end
  end

  def self.string_to_digits(str)
    str.chars.map(&:to_i)
  end

  def self.binary_to_int(binary_str)
    Integer(binary_str, 2)
  end

  def self.frequency(array)
    array.each_with_object(Hash.new(0)) { |item, counts| counts[item] += 1 }
  end

  def self.gcd(a, b)
    b.zero? ? a : gcd(b, a % b)
  end

  def self.lcm(a, b)
    a * b / gcd(a, b)
  end

  def self.deep_copy(obj)
    Marshal.load(Marshal.dump(obj))
  end

  def self.manhattan_distance(x1, y1, x2, y2)
    (x1 - x2).abs + (y1 - y2).abs
  end

  def self.priority_queue(&block)
    PQueue.new(&block)
  end
end

class Object
  def show_me
    pp self
    self
  end
end
