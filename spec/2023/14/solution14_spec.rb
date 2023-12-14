require_relative "../../../2023/14/solution14"

RSpec.describe AoC::Year2023::Solution14 do
  let(:solution) { described_class.new }

  let(:sample_input) do
    <<~EXAMPLE
      O....#....
      O.OO#....#
      .....##...
      OO.#O....O
      .O.....O#.
      O.#..O.#.#
      ..O..#O..O
      .......O..
      #....###..
      #OO..#....
    EXAMPLE
  end

  context "with sample input" do
    let(:solution) { described_class.new(input: sample_input) }

    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(136)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(64)
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(107053)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(88371)
      end
    end
  end
end
