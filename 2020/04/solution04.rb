require_relative "../../lib/base"

class AoC::Year2020::Solution04 < Base
  attr_reader :passports

  REQUIRED_FIELDS = %w[byr iyr eyr hgt hcl ecl pid].freeze
  VALID_EYE_COLORS = %w[amb blu brn gry grn hzl oth].freeze

  def part1
    parse_passports.count { |passport| valid_passport_part1?(passport) }
  end

  def part2
    parse_passports.count { |passport| valid_passport_part2?(passport) }
  end

  private

  def parse_passports
    input.split("\n\n").map do |passport|
      passport.split(/\s+/).map { |field| field.split(":") }.to_h
    end
  end

  def valid_passport_part1?(passport)
    (REQUIRED_FIELDS - passport.keys).empty?
  end

  def valid_passport_part2?(passport)
    valid_passport_part1?(passport) && passport.all? { |key, value| valid_field?(key, value) }
  end

  def valid_field?(key, value)
    case key
    when "byr" then value.to_i.between?(1920, 2002)
    when "iyr" then value.to_i.between?(2010, 2020)
    when "eyr" then value.to_i.between?(2020, 2030)
    when "hgt" then valid_height?(value)
    when "hcl" then value.match?(/\A#[0-9a-f]{6}\z/)
    when "ecl" then VALID_EYE_COLORS.include?(value)
    when "pid" then value.match?(/\A\d{9}\z/)
    when "cid" then true
    else false
    end
  end

  def valid_height?(height)
    if (match = height.match(/\A(\d+)(cm|in)\z/))
      value, unit = match.captures
      case unit
      when "cm" then value.to_i.between?(150, 193)
      when "in" then value.to_i.between?(59, 76)
      else false
      end
    else
      false
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2020::Solution04.new
  solution.run
end
