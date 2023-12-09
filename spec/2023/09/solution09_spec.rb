require_relative "../../../2023/09/solution09"

RSpec.describe AoC::Year2023::Solution09 do
  let(:solution) { described_class.new }

  let(:sample_input) do
    <<~EXAMPLE1
      0 3 6 9 12 15
      1 3 6 10 15 21
      10 13 16 21 30 45
    EXAMPLE1
  end

  context "with sample input" do
    let(:solution) { described_class.new(input: sample_input) }

    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(114)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(2)
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(1995001648)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(988)
      end
    end
  end
end
