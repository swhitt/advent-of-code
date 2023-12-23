require_relative "../../lib/base"

# Solution for the 2023 day 20 puzzle
# https://adventofcode.com/2023/day/20
module AoC::Year2023
  class Solution20 < Base
    def initialize(...)
      super
      @first_high_pulse_by_module = {}
      @modules = {}
      parse_input
    end

    def part1(button_presses: 1000)
      button_presses.times.reduce([0, 0]) do |acc, _|
        simulate_pulse_propagation.zip(acc).map { |pulse_count, total| pulse_count + total }
      end.reduce(:*)
    end

    def part2
      Util.lcm(*simulate_until_first_high_per_input(target_module: "qt"))
    end

    def parse_input
      @modules.clear
      @module_inputs = Hash.new { |h, k| h[k] = Set.new }

      input.each_line do |line|
        name, destinations = line.split(" -> ").map(&:strip)
        module_type, name = name[0], name[1..] unless name == "broadcaster"

        @modules[name] = create_module(name, module_type)
        destinations.split(",").map(&:strip).each do |dest|
          @modules[name].destinations << dest
          @module_inputs[dest] << name
        end
      end

      @module_inputs.each do |module_name, inputs|
        inputs.each { @modules[module_name]&.inputs&.add(_1) }
      end
    end

    def create_module(name, module_type)
      case module_type
      when "%"
        FlipFlopModule.new(name)
      when "&"
        ConjunctionModule.new(name)
      else
        BroadcasterModule.new(name)
      end
    end

    def simulate_pulse_propagation(watch_high_inputs_for: "qt", button_press: 1)
      counts = {low: 1, high: 0}
      queue = [["broadcaster", :low, nil]]

      until queue.empty?
        module_name, pulse, source = queue.shift
        current_module = @modules[module_name]
        next unless current_module

        next_pulse = current_module.process_pulse(pulse, source)
        next if next_pulse.nil?

        current_module.destinations.each do |destination_name|
          counts[next_pulse] += 1

          record_first_high_pulse(destination_name, module_name, button_press, next_pulse) if destination_name == watch_high_inputs_for
          queue.push([destination_name, next_pulse, module_name])
        end
      end

      [counts[:low], counts[:high]]
    end

    def simulate_until_first_high_per_input(target_module:)
      reset_modules
      input_count = @modules[target_module].inputs.size
      (1..).each do |i|
        simulate_pulse_propagation(watch_high_inputs_for: target_module, button_press: i)
        break if @first_high_pulse_by_module.size >= input_count
      end
      @first_high_pulse_by_module.values
    end

    def reset_modules
      @first_high_pulse_by_module.clear
      @modules.values.each(&:reset)
    end

    def record_first_high_pulse(destination_name, module_name, button_press, next_pulse)
      @first_high_pulse_by_module[module_name] ||= button_press if next_pulse == :high
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
      puts "  rx[(rx)]"
      @modules.each do |name, mod|
        mod.destinations.each do |destination_name|
          puts "  #{name} --> #{destination_name}"
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
    end

    def reset
    end

    def process_pulse(_pulse, _source)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end
  end

  class FlipFlopModule < BaseModule
    def initialize(name)
      super
      reset
    end

    def reset
      @state = false
      @last_pulse = nil
    end

    def process_pulse(pulse, _source)
      return if pulse == :high # Ignore high pulses
      @state = !@state
      @last_pulse = @state ? :high : :low
    end
  end

  class ConjunctionModule < BaseModule
    def initialize(name)
      super
      reset
    end

    def reset
      @input_signals = Hash.new(:low)
      @last_pulse = nil
    end

    def process_pulse(pulse, source)
      @input_signals[source] = pulse
      @last_pulse = if inputs.size > @input_signals.size
        :high
      else
        @input_signals.values.all?(:high) ? :low : :high
      end
    end
  end

  class BroadcasterModule < BaseModule
    def process_pulse(pulse, _source)
      @last_pulse = pulse
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2023::Solution20.new
  solution.run
end
