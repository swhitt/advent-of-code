# spec/2023/07/solution07_spec.rb
require_relative "../../../2023/07/solution07"

RSpec.describe AoC::Year2023::Solution07 do
  let(:solution) { described_class.new }

  let(:sample_input) do
    <<~EXAMPLE1
      32T3K 765
      T55J5 684
      KK677 28
      KTJJT 220
      QQQJA 483
    EXAMPLE1
  end

  context "with sample input" do
    let(:solution) { described_class.new(input: sample_input) }

    describe "#hands" do
      it "returns the correct hands" do
        expect(solution.hands).to eq([
          [%w[3 2 T 3 K], 765],
          [%w[T 5 5 J 5], 684],
          [%w[K K 6 7 7], 28],
          [%w[K T J J T], 220],
          [%w[Q Q Q J A], 483]
        ])
      end
    end

    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(6440)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(5905)
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(250474325)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(248909434)
      end
    end
  end

  describe "#compare" do
    it "compares hands" do
      expect(solution.compare("33332", "2AAAA")).to eq(1)
      expect(solution.compare("33332", "AAAA2")).to eq(-1)
      expect(solution.compare("2AAAA", "33332")).to eq(-1)
      expect(solution.compare("2AAAA", "2AAAA")).to eq(0)
    end
  end
end
