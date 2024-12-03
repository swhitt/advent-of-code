require_relative "../../../2024/03/solution03"

RSpec.describe AoC::Year2024::Solution03 do
  let(:solution) { described_class.new }

  let(:sample_input) do
    "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
  end

  let(:sample_input2) do
    "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  end

  context "with sample input" do
    let(:solution) { described_class.new(input: sample_input) }

    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(161)
      end
    end

    let(:solution2) { described_class.new(input: sample_input2) }
    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution2.part2).to eq(48)
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(192767529)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(104083373)
      end
    end
  end
end
