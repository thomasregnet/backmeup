# frozen_string_literal: true

RSpec.describe Backmeup::DestinationLayout do
  let(:destination) { 'some_destination' }
  let(:root) { instance_double('Backmeup::Root') }

  subject  { described_class.new(destination: destination, root: root) }
  before { allow(root).to receive(:backups).and_return('backups') }

  describe '#data' do
    it 'returns the data-path' do
      path = File.join('backups', destination, 'data')
      expect(subject.data).to eq(path)
    end
  end

  describe '#stderr' do
    it 'returns the stderr-path' do
      path = File.join('backups', destination, 'stderr')
      expect(subject.stderr).to eq(path)
    end
  end

  describe '#stdout' do
    it 'returns the stdout-path' do
      path = File.join('backups', destination, 'stdout')
      expect(subject.stdout).to eq(path)
    end
  end
end
