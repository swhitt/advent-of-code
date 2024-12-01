require "bundler/setup"
require "pry"
require "benchmark"
require_relative "input_manager"
require_relative "util"

module AoC
  (2019..Time.now.year).each do |year|
    const_set(:"Year#{year}", Module.new)
  end
end

class Base
  @solution_path = nil

  class << self
    attr_accessor :solution_path

    def inherited(subclass)
      super
      caller_file = caller_locations(1..1).first.absolute_path
      subclass.solution_path = File.dirname(caller_file)

      at_exit do
        if File.expand_path($PROGRAM_NAME) == File.expand_path($0) && !defined?(RSpec)
          subclass.new.run
        end
      end
    end

    def memoize(method_name)
      original_method = instance_method(method_name)
      define_method(method_name) do |*args, **kwargs|
        @_memoize_cache ||= {}
        @_memoize_cache[[method_name, args, kwargs].hash] ||= original_method.bind_call(self, *args, **kwargs)
      end
    end
  end

  attr_reader :input

  def initialize(input: nil, input_filename: "input.txt")
    @input = if input
      input
    else
      input_path = File.join(self.class.solution_path, input_filename)
      puts "Loading input from #{input_path}" unless ENV.key?("TEST")

      begin
        File.read(input_path)
      rescue Errno::ENOENT
        warn "Input file not found: #{input_path}"
        []
      rescue => e
        warn "Error reading input file: #{e.message}"
        []
      end
    end
  end

  def part1(input)
    raise NotImplementedError, "Please implement part1"
  end

  def part2(input)
    raise NotImplementedError, "Please implement part2"
  end

  def input_lines = input.split("\n")

  def run(debug = true)
    results = {
      part1: benchmark { execute_and_rescue(:part1) },
      part2: benchmark { execute_and_rescue(:part2) }
    }

    results.each do |part, (duration, _)|
      puts "#{part.capitalize} time: #{format_duration(duration)}"
    end

    binding.pry if debug # rubocop:disable Lint/Debugger
  end

  private

  def benchmark
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    result = yield
    duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
    [duration, result]
  end

  def execute_and_rescue(method_name)
    result = send(method_name)
    puts "#{method_name.to_s.capitalize}: #{result}"
    result
  rescue => e
    puts "#{method_name.to_s.capitalize} failed: #{e.class} - #{e.message}"
    puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
    nil
  end

  def format_duration(seconds)
    case seconds
    when 0...5
      milliseconds = seconds * 1000
      if milliseconds < 1
        "#{(milliseconds * 1000).round(2)}μs"
      else
        "#{milliseconds.round(2)}ms"
      end
    else
      Time.at(seconds).utc.strftime("%Hh %Mm %Ss")
    end
  end
end
