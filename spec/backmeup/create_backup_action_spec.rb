# frozen_string_literal: true

require 'support/shared_examples_for_actions'
require 'support/shared_examples_for_hookable_actions'
require 'support/shared_examples_for_scriptable_actions'

RSpec.describe Backmeup::CreateBackupAction do
  subject do
    described_class.new(
      destination:          'my_destination',
      previous_destination: nil,
      root:                 Backmeup::Root.new('tmp')
    )
  end

  it_behaves_like 'an action'

  it_behaves_like 'a hookable action' do
    let(:script_name) { 'create_backup' }
  end

  it_behaves_like 'a scriptable action' do
    let(:script_name) { 'create_backup' }
  end

  describe '.perform' do
    let(:repository) { File.join('tmp', 'repository') }

    let(:backups) { File.join('tmp', 'repository', 'backups') }
    let(:destination) { File.join('tmp', 'repository', 'backups', '2020-01-01T11:24:00+02:00') }
    let(:source) { File.join('tmp', 'source') }

    before do
      FileUtils.mkpath(File.join(source))
      FileUtils.touch(File.join(source, 'data.txt'))

      config_dir = File.join('tmp', 'repository', 'config')
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
      let(:expected_file) do
        File.join(
          repository, 'backups', destination, 'data', 'source', 'data.txt'
        )
      end

      before do
        described_class.perform(
          destination:          destination,
          previous_destination: nil,
          root:                 Backmeup::Root.new(repository)
        )
      end

      it 'creates a backup' do
        expect(Pathname.new(expected_file)).to exist
      end
    end

    context 'with a create_backup script' do
      let(:cmd) { instance_double('TTY::Command') }

      before do
        bin_dir = File.join(repository, 'bin')
        FileUtils.mkpath(bin_dir)
        FileUtils.touch(File.join(bin_dir, 'create_backup'))
        FileUtils.chmod(0o755, File.join(bin_dir, 'create_backup'))

        creator = described_class.new(
          destination:          destination,
          previous_destination: nil,
          root:                 Backmeup::Root.new(repository)
        )
        allow(TTY::Command).to receive(:new).and_return(cmd)
        result = spy
        allow(cmd).to receive(:run).and_return(result)
        allow(result).to receive(:status).and_return(0)
        creator.perform
      end

      it 'calls that script' do
        expect(cmd).to have_received(:run)
      end
    end
  end

  describe '#env' do
    context 'with a previous_destination' do
      let(:env) do
        described_class.new(
          destination:          'my_destination',
          previous_destination: 'previous_destination',
          root:                 Backmeup::Root.new('root')
        ).send(:env)
      end

      it 'sets the DESTINATION_DATA variable' do
        expect(env['DESTINATION_DATA'])
          .to eq(File.join('root', 'backups', 'my_destination', 'data'))
      end

      it 'sets the DESTINATION_PATH variable' do
        expect(env['DESTINATION_PATH'])
          .to eq(File.join('root', 'backups', 'my_destination'))
      end

      it 'sets the DESTINATION_STDERR variable' do
        expect(env['DESTINATION_STDERR'])
          .to eq(File.join('root', 'backups', 'my_destination', 'stderr'))
      end

      it 'sets the DESTINATION_STDOUT variable' do
        expect(env['DESTINATION_STDOUT'])
          .to eq(File.join('root', 'backups', 'my_destination', 'stdout'))
      end

      it 'sets the PREVIOUS_DESTINATION_DATA variable' do
        expect(env['PREVIOUS_DESTINATION_DATA'])
          .to eq(
            File.join('root', 'backups', 'previous_destination', 'data')
          )
      end

      it 'sets the PREVIOUS_DESTINATION_PATH variable' do
        expect(env['PREVIOUS_DESTINATION_PATH'])
          .to eq(File.join('root', 'backups', 'previous_destination'))
      end
    end

    context 'without a previous_destination' do
      let(:env) do
        described_class.new(
          destination:          'my_destination',
          previous_destination: nil,
          root:                 Backmeup::Root.new('root')
        ).send(:env)
      end

      it 'sets the DESTINATION_DATA variable' do
        expect(env['DESTINATION_DATA'])
          .to eq(File.join('root', 'backups', 'my_destination', 'data'))
      end

      it 'sets the DESTINATION_PATH variable' do
        expect(env['DESTINATION_PATH'])
          .to eq(File.join('root', 'backups', 'my_destination'))
      end

      it 'sets the DESTINATION_STDERR variable' do
        expect(env['DESTINATION_STDERR'])
          .to eq(File.join('root', 'backups', 'my_destination', 'stderr'))
      end

      it 'sets the DESTINATION_STDOUT variable' do
        expect(env['DESTINATION_STDOUT'])
          .to eq(File.join('root', 'backups', 'my_destination', 'stdout'))
      end

      it 'does not set the PREVIOUS_DESTINATION_DATA variable' do
        expect(env['PREVIOUS_DESTINATION_DATA']).to be_nil
      end

      it 'does not set the PREVIOUS_DESTINATION_PATH variable' do
        expect(env['PREVIOUS_DESTINATION_PATH']).to be_nil
      end
    end
  end
end
