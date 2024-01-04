require_relative "../../../2019/06/solution06"

RSpec.describe AoC::Year2019::Solution06 do
  let(:solution) { described_class.new }

  context "with sample input" do
    let(:solution) { described_class.new(input: sample_input) }

    describe "#part1" do
      let(:sample_input) do
        <<~EXAMPLE
          COM)B
          B)C
          C)D
          D)E
          E)F
          B)G
          G)H
          D)I
          E)J
          J)K
          K)L
        EXAMPLE
      end
      it "calculates the correct answer" do
        expect(solution.part1).to eq(42)
      end
    end

    describe "#part2" do
      let(:sample_input) do
        <<~EXAMPLE
          COM)B
          B)C
          C)D
          D)E
          E)F
          B)G
          G)H
          D)I
          E)J
          J)K
          K)L
          K)YOU
          I)SAN
        EXAMPLE
      end
      it "calculates the correct answer" do
        expect(solution.part2).to eq(4)
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(160040)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(373)
      end
    end
  end
end
