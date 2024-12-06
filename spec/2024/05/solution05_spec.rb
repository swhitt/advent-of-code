require_relative "../../../2024/05/solution05"

RSpec.describe AoC::Year2024::Solution05 do
  let(:solution) { described_class.new }

  let(:sample_input) do
    # replace with actual sample data
    <<~EXAMPLE
      47|53
      97|13
      97|61
      97|47
      75|29
      61|13
      75|53
      29|13
      97|29
      53|29
      61|53
      97|53
      61|29
      47|13
      75|47
      97|75
      47|61
      75|61
      47|29
      75|13
      53|13

      75,47,61,53,29
      97,61,53,29,13
      75,29,13
      75,97,47,61,53
      61,13,29
      97,13,75,29,47
    EXAMPLE
  end

  context "with sample input" do
    let(:solution) { described_class.new(input: sample_input) }

    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(143)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(123)
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(4637)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        pending("need real part2 answer")
        expect(solution.part2).to eq(6370)
      end
    end
  end
end
