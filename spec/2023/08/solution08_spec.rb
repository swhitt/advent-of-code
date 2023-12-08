require_relative "../../../2023/08/solution08"

RSpec.describe AoC::Year2023::Solution08 do
  let(:solution) { described_class.new }

  context "with example input 1" do
    let(:sample_input) do
      <<~EXAMPLE1
        LLR

        AAA = (BBB, BBB)
        BBB = (AAA, ZZZ)
        ZZZ = (ZZZ, ZZZ)
      EXAMPLE1
    end

    let(:solution) { described_class.new(input: sample_input) }

    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(6)
      end
    end
  end

  context "with example input 2" do
    let(:sample_input) do
      <<~EXAMPLE2
        LR

        11A = (11B, XXX)
        11B = (XXX, 11Z)
        11Z = (11B, XXX)
        22A = (22B, XXX)
        22B = (22C, 22C)
        22C = (22Z, 22Z)
        22Z = (22B, 22B)
        XXX = (XXX, XXX)
      EXAMPLE2
    end

    let(:solution) { described_class.new(input: sample_input) }

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(6)
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(14681)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(14_321_394_058_031)
      end
    end
  end
end
