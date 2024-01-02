require_relative "../../../2019/05/solution05"

RSpec.describe AoC::Year2019::Solution05 do
  let(:solution) { described_class.new }

  let(:sample_input) do
    "3,0,4,0,99"
  end

  context "with sample input" do
    let(:solution) { described_class.new(input: sample_input) }

    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(1)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(5)
      end
    end

    describe "#part2 example 2" do
      let(:sample_input) do
        "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002," \
          "21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
      end
      it "calculates the correct answer" do
        expect(solution.part2).to eq(999)
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(9006673)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(3629692)
      end
    end
  end
end
