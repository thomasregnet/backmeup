# frozen_string_literal: true

require 'backmeup/commands/create'

RSpec.describe Backmeup::Commands::Create do
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
      allow(Expire).to receive(:newest)
      create = described_class.new('tmp', {})
      create.execute
      expect(Expire).to have_received(:newest).at_least(2).times
    end

    it 'calls Backmeup::CreateDestinationAction.perform' do
      allow(Backmeup::CreateDestinationAction).to receive(:perform)
      create = described_class.new('tmp', {})
      create.execute
      expect(Backmeup::CreateDestinationAction).to have_received(:perform)
    end

    it 'calls Backmeup::CreateBackupAction.perform' do
      allow(Backmeup::CreateBackupAction).to receive(:perform)
      create = described_class.new('tmp', {})
      create.execute
      expect(Backmeup::CreateBackupAction).to have_received(:perform)
    end
  end
end
