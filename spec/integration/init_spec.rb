# frozen_string_literal: true

RSpec.describe '`backmeup init` command', type: :cli do
  it 'executes `backmeup help init` command successfully' do
    output = `backmeup help init`
    expected_output = <<~OUT
      Usage:
        backmeup init PATH
      
      Options:
        -h, [--help], [--no-help]  # Display usage information
      
      Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
