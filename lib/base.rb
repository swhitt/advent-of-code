require "bundler/setup"
require "pry"
require "benchmark"
require_relative "input_manager"
require_relative "util"

module AoC
  module Year2020
  end

  module Year2021
  end

  module Year2022
  end

  module Year2023
  end
end

class Base
  @solution_path = nil

  class << self
    attr_accessor :solution_path

    def inherited(subclass)
      subclass.solution_path = File.dirname(caller_locations(1..1).first.absolute_path)
      super
    end

    def memoize(method_name)
      original_method = instance_method(method_name)
      define_method(method_name) do |*args, **kwargs|
        @_memoize_cache ||= {}
        cache_key = [method_name, args, kwargs].hash
        @_memoize_cache[cache_key] ||= original_method.bind_call(self, *args, **kwargs)
      end
    end
  end

  attr_accessor :input

  def initialize(input: nil, input_filename: "input.txt")
    if input
      puts "Loading input from argument!"
      @input = input
      return
    end

    input_path = File.join(self.class.solution_path, input_filename)

    puts "Loading input from #{input_path}"
    begin
      @input = File.read(input_path)
    rescue Errno::ENOENT
      warn "Input file not found: #{input_path}"
      @input = []
    rescue => e
      warn "Error reading input file: #{e.message}"
      @input = []
    end
  end

  def part1(input)
    raise NotImplementedError, "Please implement part1"
  end

  def part2(input)
    raise NotImplementedError, "Please implement part2"
  end

  def input_lines
    input.split("\n")
  end

  def run(debug = true)
    part1_time = Benchmark.realtime { execute_and_rescue(:part1) }
    part2_time = Benchmark.realtime { execute_and_rescue(:part2) }

    puts "\nPart1 time: #{format_duration(part1_time)}"
    puts "Part2 time: #{format_duration(part2_time)}"

    binding.pry if debug # rubocop:disable Lint/Debugger
  end

  private

  def execute_and_rescue(method_name)
    puts "#{method_name.to_s.capitalize}: #{send(method_name)}"
  rescue => e
    puts "#{method_name.to_s.capitalize} failed: #{e.class} - #{e.message}"
    puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
  end

  def format_duration(seconds)
    case seconds
    when 0...5
      milliseconds = seconds * 1000
      if milliseconds < 1
        microseconds = milliseconds * 1000
        "#{microseconds.round(2)}μs"
      else
        "#{milliseconds.round(2)}ms"
      end
    else
      Time.at(seconds).utc.strftime("%Hh %Mm %Ss")
    end
  end
end
