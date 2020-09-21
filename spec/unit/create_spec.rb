# frozen_string_literal: true

require 'backmeup/commands/create'

RSpec.describe Backmeup::Commands::Create do
  # it 'executes `create` command successfully' do
  #   output = StringIO.new
  #   repository = 'tmp'
  #   options = {}
  #   command = Backmeup::Commands::Create.new(repository, options)

  #   command.execute(output: output)

  #   expect(output.string).to eq("OK\n")
  # end

  describe '.execute' do
    let(:repository) { 'tmp' }

    before do
      FileUtils.mkpath(File.join(repository, 'backups'))

      allow(Expire).to receive(:newest).and_return(nil)
      allow(Backmeup::CreateDestinationAction).to receive(:perform)
        .and_return(nil)
      allow(Backmeup::CreateBackupAction).to receive(:perform).and_return(nil)
    end

    after do
      FileUtils.rm_rf(File.join(repository, 'backups'))
    end

    it 'calls Expire.newest' do
      expect(Expire).to receive(:newest)
      create = described_class.new('tmp', {})
      create.execute
    end

    it 'calls Backmeup::CreateDestinationAction.perform' do
      expect(Backmeup::CreateDestinationAction).to receive(:perform)
      create = described_class.new('tmp', {})
      create.execute
    end

    it 'calls Backmeup::CreateBackupAction.perform' do
      expect(Backmeup::CreateBackupAction).to receive(:perform)
      create = described_class.new('tmp', {})
      create.execute
    end
  end
end
