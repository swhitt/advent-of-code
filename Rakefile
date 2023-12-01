# frozen_string_literal: true

require "erb"
require_relative "lib/aoc/helper"
require "fileutils"

namespace :aoc do
  desc "Set up the directory and solution file for a given day"
  task :setup, [:day] do |_t, args|
    day = args[:day].to_i
    day_str = day.to_s.rjust(2, "0")
    dir_path = File.join("days", "day#{day_str}")

    if File.directory?(dir_path)
      puts "Directory already exists: #{dir_path}"
    else
      FileUtils.mkdir_p(dir_path)
      puts "Created directory: #{dir_path}"
    end

    # Only download input if it's past the start time
    if AoC::Helper.start_time(day) < Time.now
      AoC::Helper.get_or_load_input(day)
    else
      puts "It's not yet time to download the input for day #{day}."
    end

    # Generate the solution file from the template
    template_path = File.join("templates", "solution_template.rb.erb")
    solution_path = File.join(dir_path, "solution#{day_str}.rb")

    if File.exist?(solution_path)
      puts "Solution file already exists: #{solution_path}"
    else
      template = ERB.new(File.read(template_path), trim_mode: "-")
      File.write(solution_path, template.result(binding))
      puts "Created solution file: #{solution_path}"
    end
  end
end
