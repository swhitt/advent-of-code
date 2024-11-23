require "bundler/setup"
require "pry"
require "benchmark"
require "memo_wise"
require_relative "input_manager"
require_relative "util"

module AoC
  SUPPORTED_YEARS = (2015..Time.now.year)

  SUPPORTED_YEARS.each do |year|
    const_set(:"Year#{year}", Module.new)
  end
end

class Base
  prepend MemoWise

  singleton_class.attr_accessor :autorun_enabled
  @autorun_enabled = true

  at_exit { Base.autorun if $PROGRAM_NAME == $0 && Base.autorun_enabled }

  class << self
    def autorun
      return unless /solution\d{1,2}\.rb$/.match?($PROGRAM_NAME)

      klass_path = File.expand_path($PROGRAM_NAME)
      if (match = klass_path.match(%r{(?<year>\d{4})/(?<day>\d{1,2})/solution\d{1,2}\.rb$}))
        solution_class = Object.const_get("AoC::Year#{match[:year]}::Solution#{match[:day]}")
        solution_class.new.run
      end
    end
  end

  attr_accessor :input

  def initialize(input: nil, input_filename: "input.txt")
    @input = input || load_input_file(input_filename)
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
    %i[part1 part2].each do |part|
      puts unless part == :part1
      time = Benchmark.realtime { execute_part(part) }
      puts "#{part.capitalize} time: #{format_duration(time)}"
    end

    binding.pry if debug # rubocop:disable Lint/Debugger
  end

  COLOR_CODES = {
    red: 31, green: 32, yellow: 33,
    blue: 34, magenta: 35, cyan: 36
  }.freeze

  def color_print(str, color = :yellow)
    puts "\e[#{COLOR_CODES.fetch(color, 33)}m#{str}\e[0m"
  end

  private

  def execute_part(part)
    result = public_send(part)
    color_print("#{part.capitalize}: #{result}", :cyan)
  rescue => e
    color_print("#{part.capitalize} failed: #{e.class} - #{e.message}", :red)
    color_print("Backtrace:\n\t#{e.backtrace.join("\n\t")}", :red)
  end

  def format_duration(seconds)
    if seconds < 5
      time_ms = seconds * 1000
      (time_ms < 1) ? "#{(time_ms * 1000).round(2)}μs" : "#{time_ms.round(2)}ms"
    else
      Time.at(seconds).utc.strftime("%Hh %Mm %Ss")
    end
  end

  def load_input_file(input_filename)
    input_path = File.join(solution_path, input_filename)
    puts "Loading input from #{input_path}" unless ENV.key?("TEST")

    File.read(input_path)
  rescue => e
    warn "Error reading input file: #{e.message}"
    []
  end

  def solution_path
    File.dirname(File.expand_path($PROGRAM_NAME))
  end
end
