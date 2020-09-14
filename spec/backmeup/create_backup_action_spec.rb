# frozen_string_literal: true

require 'support/shared_examples_for_actions'
require 'support/shared_examples_for_scriptable_actions'

RSpec.describe Backmeup::CreateBackupAction do
  subject do
    described_class.new(
      destination: 'my_destination',
      previous_destination: nil,
      root: :fake_root
    )
  end

  it_behaves_like 'an action'
  it_behaves_like 'a scriptable action' do
    let(:script_name) { 'create_backup' }
  end

  describe '.perform' do
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

    context 'without a script' do
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

    context 'with a create_backup script' do
      let(:creator) do
        described_class.new(
          destination: destination,
          previous_destination: nil,
          root: Backmeup::Root.new(repository)
        )
      end

      let(:bin) { File.join(repository, 'bin') }
      let(:cmd) { instance_double('TTY::Command') }

      before do
        FileUtils.mkpath(bin)
        FileUtils.touch(File.join(bin, 'create_backup'))
        FileUtils.chmod(0o755, File.join(bin, 'create_backup'))

        allow(creator).to receive(:cmd).and_return(cmd)
        allow(cmd).to receive(:run)
      end

      it 'calls that script' do
        creator.perform
        expect(cmd).to have_received(:run)
      end
    end
  end
end
