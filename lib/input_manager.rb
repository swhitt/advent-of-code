require "net/http"
require "uri"
require "tzinfo"
require "fileutils"

module AoC
  module InputManager
    SESSION_COOKIE = ENV.fetch("AOC_SESSION", nil)

    class << self
      def input_for(day, year = Time.now.year)
        day = day.to_i
        year = year.to_i
        path = input_file_path(day, year)
        return File.readlines(path) if File.exist?(path)

        wait_until_available(day, year)
        download_and_save_input(day, year)
      end

      def input_file_path(day, year = Time.now.year)
        File.join(__dir__, "..", year.to_s, day.to_s.rjust(2, "0"), "input.txt")
      end

      def wait_until_available(day, year = Time.now.year)
        start_time = puzzle_start_time(year, day)
        return if Time.now >= start_time

        puts "Waiting for Day #{day}, #{year} to become available..."
        display_countdown(start_time, day, year)
        puts "\nDay #{day}, #{year} is now available!"
      end

      def download_and_save_input(day, year)
        path = input_file_path(day, year)
        FileUtils.mkdir_p(File.dirname(path))

        response = fetch_input(day, year)
        return unless response.is_a?(Net::HTTPSuccess)

        File.write(path, response.body)
        puts "Day #{day}, #{year} input downloaded and saved."
        response.body.lines
      rescue => e
        puts "Error downloading input: #{e.message}"
        nil
      end

      private

      def puzzle_start_time(year, day)
        TZInfo::Timezone.get("America/New_York")
          .local_time(year, 12, day)
          .getutc + 2
      end

      def format_countdown(remaining)
        units = {d: 86400, h: 3600, m: 60, s: 1}
        parts = units.filter_map do |unit, seconds|
          value = (remaining / seconds).floor
          remaining %= seconds
          "#{value}#{unit}" if value.positive?
        end
        parts.join(" ")
      end

      def display_countdown(target_time, day, year)
        until Time.now >= target_time
          sleep 1
          print "\rAvailable in #{format_countdown(target_time - Time.now)}..."
        end
      end

      def fetch_input(day, year)
        url = URI("https://adventofcode.com/#{year}/day/#{day}/input")
        request = Net::HTTP::Get.new(url)
        request["Cookie"] = "session=#{SESSION_COOKIE}"

        Net::HTTP.start(url.host, url.port, use_ssl: true) { |http| http.request(request) }
      end
    end
  end
end
