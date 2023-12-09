require_relative "../../../2020/02/solution02"

RSpec.describe AoC::Year2020::Solution02 do
  let(:solution) { described_class.new }

  let(:sample_input) do
    <<~EXAMPLE
      1-3 a: abcde
      1-3 b: cdefg
      2-9 c: ccccccccc
    EXAMPLE
  end

  context "with sample input" do
    let(:solution) { described_class.new(input: sample_input) }

    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(2)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(1)
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(483)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(482)
      end
    end
  end
end
