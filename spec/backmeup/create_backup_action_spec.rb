# frozen_string_literal: true

require 'support/shared_examples_for_actions'

RSpec.describe Backmeup::CreateBackupAction do
  it_behaves_like 'an action'

  describe '.perform' do
    context 'with a filelist' do
      let(:repository) { File.join('tmp', 'repository') }

      let(:backups) { File.join(repository, 'backups') }
      let(:config_dir) { File.join(repository, 'config') }
      let(:destination) { '2020-01-01T11:24:00+02:00' }
      let(:source) { File.join('tmp', 'source') }

      before do
        FileUtils.mkpath(File.join(source))
        FileUtils.touch(File.join(source, 'data.txt'))

        FileUtils.mkpath(config_dir)
        File.open(File.join(config_dir, 'filelist'), 'w') do |file|
          file.puts(File.join('tmp', 'source'))
        end

        FileUtils.mkpath(File.join(backups, destination, 'data'))
      end

      after do
        FileUtils.rm_rf(repository)
        FileUtils.rm_rf(source)
      end

      it 'creates a backup' do
        expected_file = File.join(
          repository, 'backups', destination, 'data', 'source', 'data.txt'
        )

        described_class.perform(
          destination: destination,
          previous_destination: nil,
          root: Backmeup::Root.new(repository)
        )
        expect(Pathname.new(expected_file)).to exist
      end
    end
  end
end
