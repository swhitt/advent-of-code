require_relative "../../../2023/21/solution21"

RSpec.describe AoC::Year2023::Solution21 do
  let(:solution) { described_class.new }

  let(:sample_input) do
    # replace with actual sample data
    <<~EXAMPLE
      ...........
      .....###.#.
      .###.##..#.
      ..#.#...#..
      ....#.#....
      .##..S####.
      .##..#...#.
      .......##..
      .##.#.####.
      .##..##.##.
      ...........
    EXAMPLE
  end

  context "with sample input" do
    let(:solution) { described_class.new(input: sample_input) }

    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1(max_steps: 6)).to eq(16)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        pending("need to finish part1 first")
        expect(solution.part2).to eq("part2 answer")
      end
    end
  end

  context "with real input" do
    describe "#part1" do
      it "calculates the correct answer" do
        expect(solution.part1).to eq(3724)
      end
    end

    describe "#part2" do
      it "calculates the correct answer" do
        pending("need real part2 answer")
        expect(solution.part2).to eq("real answer2")
      end
    end
  end
end
