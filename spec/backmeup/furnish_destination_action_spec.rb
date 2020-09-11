# frozen_string_literal: true

require 'support/shared_examples_for_actions'

RSpec.describe Backmeup::FurnishDestinationAction do
  it_behaves_like 'an action'

  describe '.perform' do
    let(:destination) { File.join('tmp', 'test_destination') }

    before do
      FileUtils.mkpath(destination)
    end

    after { FileUtils.rm_rf(destination) }

    context 'with an empty destination' do
      before { described_class.perform(destination_path: destination) }

      it 'creates the directory "data"' do
        expect(Pathname.new(File.join(destination, 'data'))).to be_directory
      end

      it 'creates the file "stdout"' do
        expect(Pathname.new(File.join(destination, 'stdout'))).to exist
      end

      it 'creates the file "stderr"' do
        expect(Pathname.new(File.join(destination, 'stderr'))).to exist
      end
    end

    context 'with an furnished destination' do
      before do
        FileUtils.mkpath(File.join(destination, 'data'))
        FileUtils.touch(File.join(destination, 'data', 'test.txt'))

        File.open(File.join(destination, 'stdout'), 'w') do |file|
          file.puts('logs')
        end

        File.open(File.join(destination, 'stderr'), 'w') do |file|
          file.puts('errors')
        end

        described_class.perform(destination_path: destination)
      end

      it 'keeps the given data' do
        expect(Pathname.new(File.join(destination, 'data', 'test.txt')))
          .to exist
      end

      it 'clears the file "stdout"' do
        expect(Pathname.new(File.join(destination, 'stdout'))).to be_empty
      end

      it 'clears the file "stderr"' do
        expect(Pathname.new(File.join(destination, 'stderr'))).to be_empty
      end
    end
  end
end
