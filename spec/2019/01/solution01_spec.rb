require_relative "../../../2019/01/solution01"

RSpec.describe AoC::Year2019::Solution01 do
  let(:solution) { described_class.new }

  let(:sample_input) do
    <<~EXAMPLE
      12
      14
      1969
      100756
    EXAMPLE
  end

  context "with sample input" do
    let(:solution) { described_class.new(input: sample_input) }

    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(34241)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(51316)
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(3347838)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(5018888)
      end
    end
  end
end
