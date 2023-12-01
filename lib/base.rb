# frozen_string_literal: true

require_relative "helper"
require "bundler/setup"
require "pry"

class Base
  @solution_path = nil

  class << self
    attr_accessor :solution_path

    def inherited(subclass)
      subclass.solution_path = File.dirname(caller_locations.first.absolute_path)
      super
    end
  end

  attr_reader :input

  def initialize(input_filename = "input.txt")
    input_path = File.join(self.class.solution_path, input_filename)
    begin
      @input = File.readlines(input_path).map(&:chomp)
    rescue Errno::ENOENT
      warn "Input file not found: #{input_path}"
      @input = []
    rescue StandardError => e
      warn "Error reading input file: #{e.message}"
      @input = []
    end
  end
end
