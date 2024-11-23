require "pqueue"

module Util
  class << self
    # Array operations
    def chunk_array(array, chunk_size)
      array.each_slice(chunk_size).to_a
    end

    def deep_copy(obj)
      Marshal.load(Marshal.dump(obj))
    end

    # Grid operations
    def grid_neighbors(grid, row, col, diagonals: false)
      directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
      directions.concat([[-1, -1], [-1, 1], [1, -1], [1, 1]]) if diagonals

      max_row, max_col = grid.size, grid.first.size
      directions.filter_map do |dx, dy|
        new_row, new_col = row + dx, col + dy
        [new_row, new_col] if (0...max_row).cover?(new_row) && (0...max_col).cover?(new_col)
      end
    end

    def print_grid(grid, delimiter = " ")
      grid.tap { |g| g.each { |row| puts row.join(delimiter) } }
    end

    def subgrid(grid, top_left, bottom_right)
      top_row, left_col = top_left
      bottom_row, right_col = bottom_right

      grid.slice(top_row..bottom_row).map do |row|
        row.slice(left_col..right_col)
      end
    end

    def grid_to_hash(grid)
      grid.each_with_index.flat_map do |row, r|
        row.each_with_index.map { |val, c| [[r, c], val] }
      end.to_h
    end

    def hash_to_grid(hash)
      max_r = hash.keys.map(&:first).max
      max_c = hash.keys.map(&:last).max
      Array.new(max_r + 1) { |r| Array.new(max_c + 1) { |c| hash[[r, c]] } }
    end

    def visualize_path(grid, path, path_char = "•")
      grid = deep_copy(grid)
      path.each { |r, c| grid[r][c] = path_char }
      print_grid(grid)
    end

    # Number/Math operations
    def string_to_digits(str)
      str.chars.map(&:to_i)
    end

    def binary_to_int(binary_str)
      Integer(binary_str, 2)
    end

    def gcd(a, b)
      b.zero? ? a : gcd(b, a % b)
    end

    def lcm(*args)
      args.reduce(1, :lcm)
    end

    def manhattan_distance(x1, y1, x2, y2)
      (x1 - x2).abs + (y1 - y2).abs
    end

    def range_intersection(range1, range2)
      new_min = [range1.min, range2.min].max
      new_max = [range1.max, range2.max].min

      (new_min <= new_max) ? (new_min..new_max) : nil
    end

    # Geometry operations
    def picks_theorem_area(interior_points, perimeter_points)
      interior_points + perimeter_points / 2 - 1
    end

    def polygon_area(vertices)
      # Shoelace formula
      vertices.each_with_index.inject(0.0) do |acc, ((x1, y1), i)|
        x2, y2 = vertices[(i + 1) % vertices.size]
        acc + (x1 * y2) - (x2 * y1)
      end.abs / 2.0
    end

    # Graph/Path finding operations
    def priority_queue(&block)
      PQueue.new(&block)
    end

    def dijkstra(start, goal, neighbors_func)
      distances = {start => 0}
      queue = priority_queue { |a, b| distances[a] < distances[b] }
      queue << start
      came_from = {}

      until queue.empty?
        current = queue.pop
        return [distances[goal], came_from] if current == goal

        neighbors_func.call(current).each do |neighbor, cost|
          tentative = distances[current] + cost
          if !distances.key?(neighbor) || tentative < distances[neighbor]
            distances[neighbor] = tentative
            came_from[neighbor] = current
            queue << neighbor
          end
        end
      end
      nil
    end

    def bfs(start, goal_func, neighbors_func)
      queue = [start]
      visited = {start => nil}

      until queue.empty?
        current = queue.shift
        return [current, visited] if goal_func.call(current)

        neighbors_func.call(current).each do |neighbor|
          next if visited.key?(neighbor)
          visited[neighbor] = current
          queue << neighbor
        end
      end
      nil
    end
  end
end

class Object
  def show_me
    pp self
    self
  end
end
