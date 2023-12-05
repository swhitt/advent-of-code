require "erb"
require_relative "lib/input_manager"
require "fileutils"

namespace :aoc do
  desc "Set up the directory and solution file for a given year and day"
  task :setup, [:year, :day] do |_t, args|
    day = args[:day].to_i
    year = args[:year] || Time.now.year
    day_str = day.to_s.rjust(2, "0")
    year_str = year.to_s.rjust(4, "0")
    dir_path = File.join(year_str, day_str)

    if File.directory?(dir_path)
      puts "Directory already exists: #{dir_path}"
    else
      FileUtils.mkdir_p(dir_path)
      puts "Created directory: #{dir_path}"
    end

    AoC::InputManager.input_for(day, year)

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
