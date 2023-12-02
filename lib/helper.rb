# frozen_string_literal: true

require "net/http"
require "uri"
require "tzinfo"

module AoC
  module Helper
    SESSION_COOKIE = ENV.fetch("AOC_SESSION_COOKIE", nil)
    @input_file_paths = {}

    class << self
      attr_reader :input_file_paths

      def input_file_path(day, year = Time.now.year)
        @input_file_paths[day] ||= File.join(__dir__, "..", "days", year.to_s, "day#{day.to_s.rjust(2, '0')}", "input.txt")
      end

      def get_or_load_input(day, year = Time.now.year)
        wait_until_available(day, year)
        path = input_file_path(day, year)

        if File.exist?(path)
          puts "Input for day #{day}, year #{year} already exists. Loading from disk."
          File.readlines(path)
        else
          download_and_save_input(day, year)
        end
      end

      def start_time(day, year = Time.now.year)
        tz = TZInfo::Timezone.get("America/New_York")
        tz.to_local(Time.new(year, 12, day))
      end

      def wait_until_available(day, year = Time.now.year)
        current_time = Time.now
        aoc_start_time = start_time(day, year)

        if current_time < aoc_start_time
          wait_seconds = aoc_start_time - current_time
          puts "Day #{day}, year #{year} is not available yet. Waiting #{wait_seconds} seconds until it becomes available..."
          sleep(wait_seconds)
        end
      end

      private

      def download_and_save_input(day, year = Time.now.year)
        path = input_file_path(day, year)
        FileUtils.mkdir_p(File.dirname(path))

        url = URI("https://adventofcode.com/#{year}/day/#{day}/input")
        request = Net::HTTP::Get.new(url)
        request["Cookie"] = "session=#{SESSION_COOKIE}"

        begin
          response = Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == "https") do |http|
            http.request(request)
          end

          case response
          when Net::HTTPSuccess
            File.write(path, response.body)
            puts "Day #{day}, year #{year} input downloaded and saved successfully."
            response.body.lines
          else
            puts "Failed to download input for day #{day}, year #{year}. HTTP Status: #{response.code}"
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
