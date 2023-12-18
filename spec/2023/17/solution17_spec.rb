require_relative "../../../2023/17/solution17"

RSpec.describe AoC::Year2023::Solution17 do
  let(:solution) { described_class.new }

  let(:sample_input) do
    <<~EXAMPLE
      2413432311323
      3215453535623
      3255245654254
      3446585845452
      4546657867536
      1438598798454
      4457876987766
      3637877979653
      4654967986887
      4564679986453
      1224686865563
      2546548887735
      4322674655533
    EXAMPLE
  end

  context "with sample input" do
    let(:solution) { described_class.new(input: sample_input) }

    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(102)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(94)
      end
    end

    context "with a different sample input" do
      let :sample_input do
        <<~EXAMPLE
          111111111111
          999999999991
          999999999991
          999999999991
          999999999991
        EXAMPLE
      end

      it "calculates the correct answer" do
        expect(solution.part2).to eq(71)
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(755)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(881)
      end
    end
  end
end
