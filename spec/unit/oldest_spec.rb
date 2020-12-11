require 'backmeup/commands/oldest'

RSpec.describe Backmeup::Commands::Oldest do
  it "executes `oldest` command successfully" do
    output = StringIO.new
    repository = nil
    options = {}
    command = Backmeup::Commands::Oldest.new(repository, options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
