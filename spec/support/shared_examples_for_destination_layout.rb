# frozen_string_literal: true

RSpec.shared_examples 'a DestinationLayout' do
  describe 'Methods defined in DestinationLayout' do
    it { is_expected.to respond_to(:destination_data) }
    it { is_expected.to respond_to(:destination_stderr) }
    it { is_expected.to respond_to(:destination_stdout) }
  end

  describe 'Methods the including class must define' do
    it { is_expected.to respond_to(:destination) }
    it { is_expected.to respond_to(:root) }
  end

  let(:destination) { 'my_destination' }
  let(:path_array) { %w[path to backups] }
  let(:root) { instance_double('Backmeup::Root') }

  before do
    # rubocop:disable RSpec/SubjectStub
    allow(subject).to receive(:root).and_return(root)
    # rubocop:enable RSpec/SubjectStub
    allow(root).to receive(:backups).and_return(File.join(*path_array))
  end

  describe '#destination_data' do
    it 'returns the path to the destination data' do
      expect(subject.destination_data)
        .to eq(File.join(*path_array, destination, 'data'))
    end
  end

  describe '#destination_path' do
    it 'returns the path to the destination stderr' do
      expect(subject.destination_path)
        .to eq(File.join(*path_array, destination))
    end
  end

  describe '#destination_stderr' do
    it 'returns the path to the destination stderr' do
      expect(subject.destination_stderr)
        .to eq(File.join(*path_array, destination, 'stderr'))
    end
  end

  describe '#destination_stdout' do
    it 'returns the path to the destination stdout' do
      expect(subject.destination_stdout)
        .to eq(File.join(*path_array, destination, 'stdout'))
    end
  end
end
