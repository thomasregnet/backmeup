# frozen_string_literal: true

require 'support/shared_examples_for_actions'
require 'support/shared_examples_for_hookable_actions'
require 'support/shared_examples_for_scriptable_actions'
require 'support/shared_examples_for_destination_layout'

RSpec.describe Backmeup::FurnishDestinationAction do
  subject do
    described_class.new(
      destination: 'my_destination',
      root:        Backmeup::Root.new('tmp')
    )
  end

  it_behaves_like 'an action'

  it_behaves_like 'a DestinationLayout'

  it_behaves_like 'a hookable action' do
    let(:script_name) { 'furnish_destination' }
  end

  it_behaves_like 'a scriptable action' do
    let(:script_name) { 'furnish_destination' }
  end

  describe '.perform' do
    let(:destination) { 'test_destination' }
    let(:root) { Backmeup::Root.new('tmp') }
    let(:destination_path) { File.join('tmp', 'backups', destination) }

    before { FileUtils.mkpath(root.backups) }

    after { FileUtils.rm_rf(root.backups) }

    context 'with an empty destination' do
      before { described_class.perform(destination: destination, root: root) }

      it 'creates the directory "data"' do
        expect(Pathname.new(File.join(destination_path, 'data')))
          .to be_directory
      end

      it 'creates the file "stdout"' do
        stdout = Pathname.new(File.join(destination_path, 'stdout'))
        expect(stdout).to exist
      end

      it 'creates the file "stderr"' do
        stderr = Pathname.new(File.join(destination_path, 'stderr'))
        expect(stderr).to exist
      end
    end

    context 'with an furnished destination' do
      before do
        FileUtils.mkpath(File.join(destination_path, 'data'))
        FileUtils.touch(File.join(destination_path, 'data', 'test.txt'))

        File.open(File.join(destination_path, 'stdout'), 'w') do |file|
          file.puts('logs')
        end

        File.open(File.join(destination_path, 'stderr'), 'w') do |file|
          file.puts('errors')
        end

        described_class.perform(destination: destination, root: root)
      end

      it 'keeps the given data' do
        expect(Pathname.new(File.join(destination_path, 'data', 'test.txt')))
          .to exist
      end

      it 'clears the file "stdout"' do
        expect(Pathname.new(File.join(destination_path, 'stdout'))).to be_empty
      end

      it 'clears the file "stderr"' do
        expect(Pathname.new(File.join(destination_path, 'stderr'))).to be_empty
      end
    end

    context 'when a "furnish_destination" script exists' do
      let(:bin_path) { File.join('tmp', 'bin') }
      let(:cmd) { instance_double('TTY::Command') }

      before do
        FileUtils.mkpath(bin_path)

        script_path = File.join(bin_path, 'furnish_destination')
        FileUtils.touch(script_path)

        allow(TTY::Command).to receive(:new).and_return(cmd)
        allow(cmd).to receive(:run)
      end

      after { FileUtils.rm_rf(bin_path) }

      it 'calls cmd.run' do
        described_class.perform(destination: destination, root: root)
        expect(cmd).to have_received(:run)
      end
    end
  end

  describe '#env' do
    let(:env) do
      described_class.new(
        destination: 'my_destination',
        root:        Backmeup::Root.new('root')
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
  end
end
