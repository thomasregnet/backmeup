# frozen_string_literal: true

RSpec.describe '`backmeup create` command', type: :cli do
  it 'executes `backmeup help create` command successfully' do
    output = `backmeup help create`
    expected_output = <<~OUT
      Usage:
        backmeup create REPOSITORY
      
      Options:
        -h, [--help], [--no-help]  # Display usage information
      
      Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
