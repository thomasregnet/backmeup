require 'backmeup/commands/create'

RSpec.describe Backmeup::Commands::Create do
  it "executes `create` command successfully" do
    output = StringIO.new
    repository = nil
    options = {}
    command = Backmeup::Commands::Create.new(repository, options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
