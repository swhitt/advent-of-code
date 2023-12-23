require_relative "../../lib/base"

# Solution for the 2023 day 20 puzzle
# https://adventofcode.com/2023/day/20
module AoC::Year2023
  class Solution20 < Base
    def initialize(...)
      super
      @first_pulse_from_module = {}
    end

    def part1
      parse_input
      total_low = total_high = 0
      # mermaid_graph

      1000.times do
        low, high = simulate_pulse_propagation
        total_low += low
        total_high += high
      end
      total_low * total_high
    end

    def part2
      count_times_for_module
    end

    def count_times_for_module
      reset_modules
      i = 0
      loop do
        i += 1
        simulate_pulse_propagation(button_press: i)
        break if @first_pulse_from_module.size >= 4
      end
      Util.lcm(*@first_pulse_from_module.values)
    end

    def parse_input
      @modules = {}
      @module_inputs = Hash.new { |h, k| h[k] = Set.new }

      input.each_line do |line|
        name, destinations = line.split(" -> ")
        name = name.strip
        destinations = destinations.split(", ").map(&:strip)
        module_type = name[0]
        name = name[1..] unless name[0] == "b"

        @modules[name] = case module_type
        when "%"
          FlipFlopModule.new(name)
        when "&"
          ConjunctionModule.new(name)
        else
          BroadcasterModule.new(name)
        end.tap do |module_instance|
          destinations.each do |dest|
            module_instance.destinations << dest
            @module_inputs[dest] << name
          end
        end
      end
      @module_inputs.each do |module_name, inputs|
        inputs.each { @modules[module_name]&.inputs&.<< _1 }
      end
    end

    def simulate_pulse_propagation(accumulator: "qt", button_press: 1)
      queue = []
      low_count = high_count = 0

      queue.push(["broadcaster", :low, nil])
      low_count += 1

      until queue.empty?
        module_name, pulse, source = queue.shift
        current_module = @modules[module_name]
        next unless current_module
        next_pulse = @modules[module_name].process_pulse(pulse, source)
        next if next_pulse.nil?

        @modules[module_name].destinations.each do |destination_name|
          low_count += 1 if next_pulse == :low
          high_count += 1 if next_pulse == :high

          @first_pulse_from_module[module_name] ||= button_press if destination_name == accumulator && next_pulse == :high
          queue.push([destination_name, next_pulse, module_name])
        end
      end

      [low_count, high_count]
    end

    def reset_modules
      @first_pulse_from_module = {}
      @modules.values.each(&:reset)
    end

    def mermaid_graph
      puts "graph LR"
      @modules.each do |name, mod|
        shape = case mod
        when FlipFlopModule
          "#{name}[#{name}]"
        when ConjunctionModule
          "#{name}((#{name}))"
        when BroadcasterModule
          "#{name}{{#{name}}}"
        else
          name
        end
        puts "  #{shape}"
      end
      @modules.each do |name, mod|
        mod.destinations.each do |destination_name|
          puts "  #{module_name} --> #{destination_name}"
        end
      end
    end
  end

  class BaseModule
    attr_reader :name, :last_pulse
    attr_accessor :inputs, :destinations

    def initialize(name)
      @name = name
      @destinations = []
      @inputs = Set.new
      @last_pulse = nil
    end

    def reset
    end
  end

  class FlipFlopModule < BaseModule
    def initialize(name)
      super(name)
      @state = false
    end

    def reset
      @state = false
    end

    def process_pulse(pulse, _source)
      return nil if pulse == :high # Ignore high pulses
      @state = !@state
      @last_pulse = @state ? :high : :low
    end
  end

  class ConjunctionModule < BaseModule
    attr_reader :input_signals

    def initialize(name)
      super(name)
      @input_signals = Hash.new(:low)
    end

    def reset
      @input_signals = Hash.new(:low)
    end

    def process_pulse(pulse, source)
      @input_signals[source] = pulse
      return @last_pulse = :high if inputs.size > @input_signals.size
      @last_pulse = @input_signals.values.all?(:high) ? :low : :high
    end
  end

  class BroadcasterModule < BaseModule
    def process_pulse(pulse, _source)
      pulse
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution20.new
  solution.run
end
