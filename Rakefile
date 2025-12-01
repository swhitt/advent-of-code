require "erb"
require_relative "lib/input_manager"
require "fileutils"

namespace :aoc do
  desc "Set up the directory and solution file for a given year and day"
  task :setup, [:year, :day] do |_t, args|
    day = args[:day].to_i
    year = args[:year] || Time.now.year
    skip_spec = ENV.fetch("AOC_SKIP_SPEC", "0") == "1"
    day_str = day.to_s.rjust(2, "0")
    year_str = year.to_s.rjust(4, "0")
    dir_path = File.join(year_str, day_str)
    padded_day = day_str.rjust(2, "0")

    if File.directory?(dir_path)
      puts "Directory already exists: #{dir_path}"
    else
      FileUtils.mkdir_p(dir_path)
      puts "Created directory: #{dir_path}"
    end

    solution_path = File.join(dir_path, "solution#{day_str}.rb")

    if File.exist?(solution_path)
      puts "Solution file already exists: #{solution_path}"
    else
      template_path = File.join("templates", "solution_template.rb.erb")
      template = ERB.new(File.read(template_path), trim_mode: "-")
      File.write(solution_path, template.result(binding))
      puts "Created solution file: #{solution_path}"
    end

    unless skip_spec
      spec_dir = File.join("spec", dir_path)
      spec_path = File.join(spec_dir, "solution#{day_str}_spec.rb")
      if File.exist?(spec_path)
        puts "Spec file already exists: #{spec_path}"
      else
        FileUtils.mkdir_p(spec_dir)
        template_path = File.join("templates", "solution_spec.rb.erb")
        template = ERB.new(File.read(template_path), trim_mode: "-")
        File.write(spec_path, template.result(binding))
        puts "Created spec file: #{spec_path}"
      end
    else
      puts "Skipping spec generation (AOC_SKIP_SPEC=1)."
    end
    AoC::InputManager.input_for(day, year)
  end
end
