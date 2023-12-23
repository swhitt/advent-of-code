require_relative "../../../2023/20/solution20"

RSpec.describe AoC::Year2023::Solution20 do
  let(:solution) { described_class.new }

  let(:sample_input) do
    <<~EXAMPLE
      broadcaster -> a
      %a -> inv, con
      &inv -> b
      %b -> con
      &con -> output
    EXAMPLE
  end

  context "with sample input" do
    let(:solution) { described_class.new(input: sample_input) }

    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(11687500)
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        pending("need real part1 answer")
        expect(solution.part1).to eq(879834312)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        pending("need real part2 answer")
        expect(solution.part2).to eq(243037165713371)
      end
    end
  end
end
