require_relative "../../../2023/24/solution24"

RSpec.describe AoC::Year2023::Solution24 do
  let(:solution) { described_class.new }

  let(:sample_input) do
    <<~EXAMPLE
      19, 13, 30 @ -2,  1, -2
      18, 19, 22 @ -1, -1, -2
      20, 25, 34 @ -2, -2, -4
      12, 31, 28 @ -1, -2, -1
      20, 19, 15 @  1, -5, -3
    EXAMPLE
  end

  context "with sample input" do
    let(:test_area) do
      {
        min_x: 7,
        max_x: 27,
        min_y: 7,
        max_y: 27
      }
    end
    let(:solution) { described_class.new(input: sample_input) }

    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1(test_area:)).to eq(2)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(47)
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(16665)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(769840447420960)
      end
    end
  end
end
