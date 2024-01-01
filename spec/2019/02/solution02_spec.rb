require_relative "../../../2019/02/solution02"

RSpec.describe AoC::Year2019::Solution02 do
  let(:solution) { described_class.new }

  context "with sample input" do
    describe "#process_program" do
      it "calculates the correct answer for example 1" do
        expect(solution.process_program(input: "1,9,10,3,2,3,11,0,99,30,40,50")).to eq(
          [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50]
        )
        expect(solution.process_program(input: "1,0,0,0,99")).to eq([2, 0, 0, 0, 99])
        expect(solution.process_program(input: "2,3,0,3,99")).to eq([2, 3, 0, 6, 99])
        expect(solution.process_program(input: "2,4,4,5,99,0")).to eq([2, 4, 4, 5, 99, 9801])
        expect(solution.process_program(input: "1,1,1,4,99,5,6,0,99")).to eq([30, 1, 1, 4, 2, 5, 6, 0, 99])
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(3101878)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(8444)
      end
    end
  end
end
