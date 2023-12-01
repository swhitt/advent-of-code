# frozen_string_literal: true

require "net/http"
require "uri"
require "tzinfo"

module AoC
  module Helper
    AOC_YEAR = 2023
    AOC_URL = "https://adventofcode.com/#{AOC_YEAR}/day/%d/input".freeze
    SESSION_COOKIE = ENV.fetch("AOC_SESSION_COOKIE", nil)
    @input_file_paths = {}

    class << self
      attr_reader :input_file_paths

      def input_file_path(day)
        @input_file_paths[day] ||= File.join(__dir__, "..", "days", "day#{day.to_s.rjust(2, '0')}", "input.txt")
      end

      def get_or_load_input(day)
        wait_until_available(day)
        path = input_file_path(day)

        if File.exist?(path)
          puts "Input for day #{day} already exists. Loading from disk."
          File.readlines(path)
        else
          download_and_save_input(day)
        end
      end

      def start_time(day)
        tz = TZInfo::Timezone.get("America/New_York")
        tz.to_local(Time.new(AOC_YEAR, 12, day))
      end

      def wait_until_available(day)
        current_time = Time.now
        aoc_start_time = start_time(day)

        if current_time < aoc_start_time
          wait_seconds = aoc_start_time - current_time
          puts "Day #{day} is not available yet. Waiting #{wait_seconds} seconds until it becomes available..."
          sleep(wait_seconds)
        end
      end

      private

      def download_and_save_input(day)
        path = input_file_path(day)
        FileUtils.mkdir_p(File.dirname(path))

        url = URI(AOC_URL % day)
        request = Net::HTTP::Get.new(url)
        request["Cookie"] = "session=#{SESSION_COOKIE}"

        begin
          response = Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == "https") do |http|
            http.request(request)
          end

          case response
          when Net::HTTPSuccess
            File.write(path, response.body)
            puts "Day #{day} input downloaded and saved successfully."
            response.body.lines
          else
            puts "Failed to download input for day #{day}. HTTP Status: #{response.code}"
            nil
          end
        rescue SocketError, Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
               Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
          puts "A network error occurred while downloading the input: #{e.message}"
          nil
        end
      end
    end
  end
end
