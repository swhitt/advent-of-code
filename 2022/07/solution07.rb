require_relative "../../lib/base"

class Node
  attr_accessor :name, :size, :children

  def initialize(name, size = nil)
    @name = name
    @size = size
    @children = {}
  end

  def directory?
    size.nil?
  end

  def add_child(node)
    children[node.name] = node
  end

  def find_or_create_directory(name)
    children[name] ||= Node.new(name)
  end

  def total_size
    return size unless directory?

    @total_size ||= children.values.sum(&:total_size)
  end

  def find_all_directories(&block)
    matching_directories = []

    if directory?
      matching_directories << self if block.nil? || block.call(self)
      children.each_value do |child|
        matching_directories.concat(child.find_all_directories(&block))
      end
    end

    matching_directories
  end

  def visualize(indent = 0)
    if directory?
      puts "#{" " * indent}- #{name} (dir)"
      children.each_value { |child| child.visualize(indent + 2) }
    else
      puts "#{" " * indent}- #{name} (file, size=#{size})"
    end
  end

  def self.parse_filesystem(input_lines)
    root = Node.new("/")
    current_dir = root
    path_stack = [root]

    input_lines.each do |line|
      case line
      when /^\$ cd (.+)/
        dir_name = $1
        if dir_name == "/"
          current_dir = root
          path_stack = [root]
        elsif dir_name == ".."
          path_stack.pop
          current_dir = path_stack.last
        else
          current_dir = current_dir.find_or_create_directory(dir_name)
          path_stack.push(current_dir)
        end
      when /^\$/
        # ignore other commands
      when /^dir (.+)/
        dir_name = $1
        current_dir.add_child(Node.new(dir_name))
      when /^(\d+) (.+)/
        file_size = $1.to_i
        file_name = $2
        current_dir.add_child(Node.new(file_name, file_size))
      end
    end
    root
  end
end

class AoC::Year2022::Solution07 < Base
  STORAGE_SIZE = 70_000_000
  SIZE_NEEDED = 30_000_000

  def part1
    root.find_all_directories { |dir| dir.total_size <= 100_000 }.sum(&:total_size)
  end

  def part2
    min_to_delete = root.total_size - STORAGE_SIZE + SIZE_NEEDED
    root.find_all_directories { |dir| dir.total_size >= min_to_delete }.min_by(&:total_size).total_size
  end

  def root
    @root ||= Node.parse_filesystem(input_lines)
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2022::Solution07.new
  solution.run
end
