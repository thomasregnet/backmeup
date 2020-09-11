# frozen_string_literal: true

require 'support/shared_examples_for_actions'

RSpec.describe Backmeup::FurnishDestinationAction do
  it_behaves_like 'an action'

  describe '.perform' do
    let(:destination) { 'test_destination' }
    let(:root) { Backmeup::Root.new('tmp') }
    let(:destination_path) { File.join('tmp', 'backups', destination) }
    let(:layout) do
      Backmeup::DestinationLayout.new(destination: destination, root: root)
    end

    before { FileUtils.mkpath(root.backups) }

    after { FileUtils.rm_rf(root.backups) }

    context 'with an empty destination' do
      before { described_class.perform(layout: layout) }

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

        described_class.perform(layout: layout)
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
  end
end
