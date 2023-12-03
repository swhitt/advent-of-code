require "net/http"
require "uri"
require "tzinfo"
require "fileutils"

module AoC
  module InputManager
    SESSION_COOKIE = ENV.fetch("AOC_SESSION_COOKIE", nil)

    class << self
      def input_file_path(day, year = Time.now.year)
        file_name = "day#{day.to_s.rjust(2, "0")}.txt"
        File.join(__dir__, "..", "days", year.to_s, file_name)
      end

      def get_or_load_input(day, year = Time.now.year)
        wait_until_available(day, year)
        path = input_file_path(day, year)

        return File.readlines(path) if File.exist?(path)

        download_and_save_input(day, year)
      end

      def wait_until_available(day, year = Time.now.year)
        aoc_start_time = start_time(day, year)
        return if Time.now >= aoc_start_time

        puts "Waiting for day #{day}, year #{year} to become available..."
        sleep_until(aoc_start_time)
        puts "Day #{day}, year #{year} is now available!"
      end

      private

      def start_time(day, year)
        tz = TZInfo::Timezone.get("America/New_York")
        ny_midnight = Time.new(year, 12, day, 0, 0, 0, tz.current_period.offset.utc_total_offset)
        ny_midnight.getutc
      end

      def sleep_until(target_time)
        target_time += 1
        while Time.now < target_time
          sleep 1
          remaining_time = target_time - Time.now
          print_wait_time(remaining_time, target_time.day, target_time.year)
        end
      end

      def print_wait_time(seconds, day, year)
        days, remaining = seconds.divmod(24 * 60 * 60)
        hours, remaining = remaining.divmod(60 * 60)
        minutes, seconds = remaining.divmod(60)
        seconds = seconds.floor # Round down to the nearest whole number

        wait_time = ""
        wait_time += "#{days}d " if days > 0
        wait_time += "#{hours}h " if hours > 0 || days > 0
        wait_time += "#{minutes}m " if minutes > 0 || hours > 0 || days > 0
        wait_time += "#{seconds}s"

        print "\rDay #{day}, year #{year} will be available in #{wait_time}..."
        $stdout.flush
      end

      def download_and_save_input(day, year)
        path = input_file_path(day, year)
        FileUtils.mkdir_p(File.dirname(path))
        url = URI("https://adventofcode.com/#{year}/day/#{day}/input")

        response = fetch_input_from_url(url)
        return unless response.is_a?(Net::HTTPSuccess)

        File.write(path, response.body)
        puts "Day #{day}, year #{year} input downloaded and saved."
        response.body.lines
      end

      def fetch_input_from_url(url)
        request = Net::HTTP::Get.new(url)
        request["Cookie"] = "session=#{SESSION_COOKIE}"

        Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == "https") do |http|
          http.request(request)
        end
      rescue => e
        puts "Error downloading input: #{e.message}"
        nil
      end
    end
  end
end
