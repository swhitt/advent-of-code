require_relative "../../../2024/01/solution01"

RSpec.describe AoC::Year2024::Solution01 do
  let(:solution) { described_class.new }

  let(:sample_input) do
    <<~EXAMPLE
      3   4
      4   3
      2   5
      1   3
      3   9
      3   3
    EXAMPLE
  end

  context "with sample input" do
    let(:solution) { described_class.new(input: sample_input) }

    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(11)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(31)
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(1646452)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(23609874)
      end
    end
  end
end
