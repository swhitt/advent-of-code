require "erb"
require_relative "lib/input_manager"
require "fileutils"

namespace :aoc do
  desc "Set up the directory and solution file for a given year and day"
  task :setup, [:year, :day] do |_t, args|
    day = args.fetch(:day).to_i
    year = args.fetch(:year, Time.now.year).to_i

    day_str = format("%02d", day)
    year_str = format("%04d", year)
    dir_path = File.join(year_str, day_str)

    create_directory(dir_path)
    create_solution_file(dir_path, day_str)
    create_spec_file(dir_path, day_str)

    AoC::InputManager.input_for(day, year)
  end

  private

  def create_directory(path)
    if File.directory?(path)
      puts "Directory already exists: #{path}"
    else
      FileUtils.mkdir_p(path)
      puts "Created directory: #{path}"
    end
  end

  def create_solution_file(dir_path, day_str)
    create_file_from_template(
      File.join(dir_path, "solution#{day_str}.rb"),
      "solution_template.rb.erb"
    )
  end

  def create_spec_file(dir_path, day_str)
    spec_dir = File.join("spec", dir_path)
    FileUtils.mkdir_p(spec_dir)
    create_file_from_template(
      File.join(spec_dir, "solution#{day_str}_spec.rb"),
      "solution_spec.rb.erb"
    )
  end

  def create_file_from_template(file_path, template_name)
    if File.exist?(file_path)
      puts "File already exists: #{file_path}"
    else
      template_path = File.join("templates", template_name)
      template = ERB.new(File.read(template_path), trim_mode: "-")
      File.write(file_path, template.result(binding))
      puts "Created file: #{file_path}"
    end
  end
end
