require_relative "../../../2020/01/solution01"

RSpec.describe AoC::Year2020::Solution01 do
  let(:solution) { described_class.new }

  let(:sample_input) do
    <<~EXAMPLE
      1721
      979
      366
      299
      675
      1456
    EXAMPLE
  end

  context "with sample input" do
    let(:solution) { described_class.new(input: sample_input) }

    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(514579)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(241861950)
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(902451)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(85555470)
      end
    end
  end
end
