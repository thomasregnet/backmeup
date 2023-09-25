# frozen_string_literal: true

RSpec.describe "`backmeup init` command", type: :cli do
  let(:expected_output) do
    <<~OUT
      Usage:
        backmeup init PATH

      Options:
        -h, [--help], [--no-help]  # Display usage information

      Command description...
    OUT
  end

  it "executes `backmeup help init` command successfully" do
    output = `backmeup help init`
    expect(output).to eq(expected_output)
  end
end
