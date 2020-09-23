# frozen_string_literal: true

RSpec.shared_examples 'an example class' do
  it { is_expected.to respond_to(:script_source) }

  describe '.create' do
    it 'responds to .create' do
      expect(described_class).to respond_to(:create)
    end

    it 'creates the example' do
      described_class.create(path: 'tmp')
      example_path = Pathname.new(File.join('tmp', 'examples', script_name))
      expect(example_path).to be_executable
    end
  end
end
