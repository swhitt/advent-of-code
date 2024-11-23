require "erb"
require_relative "lib/input_manager"
require "fileutils"

namespace :aoc do
  desc "Set up the directory and solution file for a given year and day"
  task :setup, [:year, :day] do |_t, args|
    setup = SolutionSetup.new(args[:year], args[:day])
    setup.create_directory
    setup.create_solution_file
    setup.create_spec_file
    AoC::InputManager.input_for(setup.day, setup.year)
  end
end

class SolutionSetup
  attr_reader :year, :day, :year_str, :day_str, :dir_path

  def initialize(year = nil, day = nil)
    @day = day.to_i || Time.now.day
    @year = year || Time.now.year
    @day_str = @day.to_s.rjust(2, "0")
    @year_str = @year.to_s.rjust(4, "0")
    @dir_path = File.join(@year_str, @day_str)
  end

  def create_directory
    if File.directory?(dir_path)
      puts "Directory already exists: #{dir_path}"
    else
      FileUtils.mkdir_p(dir_path)
      puts "Created directory: #{dir_path}"
    end
  end

  def create_solution_file
    create_file_from_template(
      "solution#{day_str}.rb",
      "solution_template.rb.erb",
      dir_path
    )
  end

  def create_spec_file
    spec_dir = File.join("spec", dir_path)
    create_file_from_template(
      "solution#{day_str}_spec.rb",
      "solution_spec.rb.erb",
      spec_dir
    )
  end

  private

  def create_file_from_template(filename, template_name, directory)
    file_path = File.join(directory, filename)

    if File.exist?(file_path)
      puts "File already exists: #{file_path}"
      return
    end

    FileUtils.mkdir_p(directory)
    template_path = File.join("templates", template_name)
    template = ERB.new(File.read(template_path), trim_mode: "-")
    File.write(file_path, template.result(binding))
    puts "Created file: #{file_path}"
  end
end
