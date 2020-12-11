RSpec.describe "`backmeup newest` command", type: :cli do
  it "executes `backmeup help newest` command successfully" do
    output = `backmeup help newest`
    expected_output = <<-OUT
Usage:
  backmeup newest

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
