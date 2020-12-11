require 'backmeup/commands/newest'

RSpec.describe Backmeup::Commands::Newest do
  it "executes `newest` command successfully" do
    output = StringIO.new
    options = {}
    command = Backmeup::Commands::Newest.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
