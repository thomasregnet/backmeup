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
  end
end
