# frozen_string_literal: true

RSpec.describe "`backmeup oldest` command", type: :cli do
  let(:expected_output) do
    <<~OUT
      Usage:
        backmeup oldest REPOSITORY

      Options:
        -h, [--help], [--no-help], [--skip-help]  # Display usage information

      Print the oldest backup of REPOSITORY
    OUT
  end

  it "executes `backmeup help oldest` command successfully" do
    output = `backmeup help oldest`
    expect(output).to eq(expected_output)
  end
end
