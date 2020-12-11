RSpec.describe "`backmeup oldest` command", type: :cli do
  it "executes `backmeup help oldest` command successfully" do
    output = `backmeup help oldest`
    expected_output = <<-OUT
Usage:
  backmeup oldest REPOSITORY

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
