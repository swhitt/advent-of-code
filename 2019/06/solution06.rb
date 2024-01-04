require_relative "../../lib/base"

# Solution for the 2019 day 6 puzzle
# https://adventofcode.com/2019/day/6
class AoC::Year2019::Solution06 < Base
  def part1
    total_orbits(parse_orbit_map)
  end

  def part2
    orbital_transfers(parse_orbit_map, "YOU", "SAN")
  end

  def parse_orbit_map
    input_lines.each_with_object({}) do |line, orbit_map|
      center, orbiter = line.strip.split(")")
      orbit_map[orbiter] = center
    end
  end

  def count_orbits(orbit_map, object)
    orbit_map[object] ? 1 + count_orbits(orbit_map, orbit_map[object]) : 0
  end

  def total_orbits(orbit_map)
    orbit_map.keys.sum { count_orbits(orbit_map, _1) }
  end

  def path_to_com(orbit_map, object)
    [].tap do |path|
      path << object while (object = orbit_map[object])
    end
  end

  def orbital_transfers(orbit_map, start, destination)
    start_path = path_to_com(orbit_map, start)
    destination_path = path_to_com(orbit_map, destination)

    common_ancestor = (start_path & destination_path).first
    start_path.index(common_ancestor) + destination_path.index(common_ancestor)
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = AoC::Year2019::Solution06.new
  solution.run
end
