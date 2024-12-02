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
      subclass.solution_path = File.dirname(caller_locations(1..1).first.absolute_path)

      at_exit { subclass.new.run if run_at_exit? }
    end

    def memoize(method_name)
      original_method = instance_method(method_name)
      define_method(method_name) do |*args, **kwargs|
        @_memoize_cache ||= {}
        @_memoize_cache[[method_name, args, kwargs].hash] ||= original_method.bind_call(self, *args, **kwargs)
      end
    end

    private

    def run_at_exit?
      File.expand_path($PROGRAM_NAME) == File.expand_path($0) && !defined?(RSpec)
    end
  end

  attr_reader :input

  def initialize(input: nil, input_filename: "input.txt")
    @input = input || load_input(input_filename)
  end

  def part1(input)
    raise NotImplementedError, "Please implement part1"
  end

  def part2(input)
    raise NotImplementedError, "Please implement part2"
  end

  def input_lines = input.split("\n")

  def input_nums = input_lines.map { _1.split.map(&:to_i) }

  def run(debug = true)
    results = benchmark_parts
    display_results(results)
    binding.pry if debug # rubocop:disable Lint/Debugger
  end

  private

  def load_input(filename)
    input_path = File.join(self.class.solution_path, filename)
    puts "Loading input from #{input_path}" unless ENV.key?("TEST")

    File.read(input_path)
  rescue Errno::ENOENT
    warn "Input file not found: #{input_path}"
    []
  rescue => e
    warn "Error reading input file: #{e.message}"
    []
  end

  def benchmark_parts
    {
      part1: Benchmark.measure { execute_and_rescue(:part1) },
      part2: Benchmark.measure { execute_and_rescue(:part2) }
    }
  end

  def display_results(results)
    results.each do |part, result|
      puts "#{part.capitalize} time: #{format_duration(result.real)}"
    end
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
