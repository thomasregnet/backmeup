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
  end

  describe '#perform' do
    let(:backup_creator) do
      described_class.new(
        destination:          :fake_destination,
        previous_destination: :fake_previous_destination,
        root:                 :fake_root
      )
    end

    before do
      allow(backup_creator).to receive(:env).and_return({}).exactly(3).times
      allow(backup_creator).to receive(:root).and_return(:fake_root).exactly(3).times
      allow(backup_creator).to receive(:perform_without_script)
    end

    context 'without a script' do
      it 'calls #perform_without_script' do
        allow(Backmeup::ScriptIfExist).to receive(:run).and_return(false).exactly(3).times
        backup_creator.perform
        expect(backup_creator).to have_received(:perform_without_script)
      end
    end

    context 'with a script' do
      before do
        allow(Backmeup::ScriptIfExist).to receive(:run).and_return(true).exactly(3).times
      end

      it 'does not call #perform_without_script' do
        backup_creator.perform
        expect(backup_creator).not_to have_received(:perform_without_script)
      end
    end
  end

  describe '#env' do
    before do
      config_pathname = Pathname.new('tmp/root/config')
      config_pathname.mkpath
      FileUtils.touch(File.join(config_pathname, 'files'))
      FileUtils.touch(File.join(config_pathname, 'excludes'))
    end

    after { FileUtils.rm_rf(File.join('tmp', 'root')) }

    context 'with a previous_destination' do
      let(:env) do
        described_class.new(
          destination:          'my_destination',
          previous_destination: 'previous_destination',
          root:                 Backmeup::Root.new(File.join('tmp', 'root'))
        ).send(:env)
      end

      it 'sets the DESTINATION_DATA variable' do
        expect(env['DESTINATION_DATA'])
          .to eq(File.join('tmp', 'root', 'backups', 'my_destination', 'data'))
      end

      it 'sets the DESTINATION_PATH variable' do
        expect(env['DESTINATION_PATH'])
          .to eq(File.join('tmp', 'root', 'backups', 'my_destination'))
      end

      it 'sets the DESTINATION_STDERR variable' do
        expect(env['DESTINATION_STDERR'])
          .to eq(File.join('tmp', 'root', 'backups', 'my_destination', 'stderr'))
      end

      it 'sets the DESTINATION_STDOUT variable' do
        expect(env['DESTINATION_STDOUT'])
          .to eq(File.join('tmp', 'root', 'backups', 'my_destination', 'stdout'))
      end

      it 'sets the PREVIOUS_DESTINATION_DATA variable' do
        expect(env['PREVIOUS_DESTINATION_DATA'])
          .to eq(
            File.join('tmp', 'root', 'backups', 'previous_destination', 'data')
          )
      end

      it 'sets the PREVIOUS_DESTINATION_PATH variable' do
        expect(env['PREVIOUS_DESTINATION_PATH'])
          .to eq(File.join('tmp', 'root', 'backups', 'previous_destination'))
      end

      it 'sets the FILES_PATH variable' do
        expect(env['FILES_PATH']).to eq(File.join('tmp', 'root', 'config', 'files'))
      end

      it 'sets the EXCLUDES_PATH variable' do
        expect(env['EXCLUDES_PATH']).to eq(File.join('tmp', 'root', 'config', 'excludes'))
      end
    end

    context 'without a previous_destination' do
      let(:env) do
        described_class.new(
          destination:          'my_destination',
          previous_destination: nil,
          root:                 Backmeup::Root.new(File.join('tmp', 'root'))
        ).send(:env)
      end

      it 'sets the DESTINATION_DATA variable' do
        expect(env['DESTINATION_DATA'])
          .to eq(File.join('tmp', 'root', 'backups', 'my_destination', 'data'))
      end

      it 'sets the DESTINATION_PATH variable' do
        expect(env['DESTINATION_PATH'])
          .to eq(File.join('tmp', 'root', 'backups', 'my_destination'))
      end

      it 'sets the DESTINATION_STDERR variable' do
        expect(env['DESTINATION_STDERR'])
          .to eq(File.join('tmp', 'root', 'backups', 'my_destination', 'stderr'))
      end

      it 'sets the DESTINATION_STDOUT variable' do
        expect(env['DESTINATION_STDOUT'])
          .to eq(File.join('tmp', 'root', 'backups', 'my_destination', 'stdout'))
      end

      it 'does not set the PREVIOUS_DESTINATION_DATA variable' do
        expect(env['PREVIOUS_DESTINATION_DATA']).to be_nil
      end

      it 'does not set the PREVIOUS_DESTINATION_PATH variable' do
        expect(env['PREVIOUS_DESTINATION_PATH']).to be_nil
      end

      it 'sets the FILES_PATH variable' do
        expect(env['FILES_PATH']).to eq(File.join('tmp', 'root', 'config', 'files'))
      end

      it 'sets the EXCLUDES_PATH variable' do
        expect(env['EXCLUDES_PATH']).to eq(File.join('tmp', 'root', 'config', 'excludes'))
      end
    end
  end
end
