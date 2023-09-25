# frozen_string_literal: true

RSpec.describe "`backmeup newest` command", type: :cli do
  let(:expected_output) do
    <<~OUT
      Usage:
        backmeup newest REPOSITORY

      Options:
        -h, [--help], [--no-help]  # Display usage information

      Print the newest backup of REPOSITORY
    OUT
  end

  it "executes `backmeup help newest` command successfully" do
    output = `backmeup help newest`
    expect(output).to eq(expected_output)
  end
end
