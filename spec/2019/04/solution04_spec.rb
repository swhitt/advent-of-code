require_relative "../../../2019/04/solution04"

RSpec.describe AoC::Year2019::Solution04 do
  let(:solution) { described_class.new }
  context "with sample input" do
    describe "#calculate_valid_password?" do
      it "calculates the correct answers for part 1" do
        expect(solution.valid_password?(111111)).to eq(true)
        expect(solution.valid_password?(223450)).to eq(false)
        expect(solution.valid_password?(123789)).to eq(false)
      end
      it "calculates the correct answers for part 2" do
        expect(solution.valid_password?(112233, strict: true)).to eq(true)
        expect(solution.valid_password?(123444, strict: true)).to eq(false)
        expect(solution.valid_password?(111122, strict: true)).to eq(true)
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(1019)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        expect(solution.part2).to eq(660)
      end
    end
  end
end
