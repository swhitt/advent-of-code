require_relative "../../../2023/11/solution11"

RSpec.describe AoC::Year2023::Solution11 do
  let(:solution) { described_class.new }

  let(:sample_input) do
    <<~EXAMPLE
      ...#......
      .......#..
      #.........
      ..........
      ......#...
      .#........
      .........#
      ..........
      .......#..
      #...#.....
    EXAMPLE
  end

  context "with sample input" do
    let(:solution) { described_class.new(input: sample_input) }

    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(374)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2(expansion_factor: 10)).to eq(1030)
        expect(solution.part2(expansion_factor: 100)).to eq(8410)
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(9563821)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(827009909817)
      end
    end
  end
end
