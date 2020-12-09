# frozen_string_literal: true

RSpec.shared_examples 'an example class' do
  it { is_expected.to respond_to(:script_source) }

  describe '.create' do
    let(:path) { 'tmp' }
    let(:examples_path) { File.join(path, 'examples') }

    after { FileUtils.rm_rf(examples_path) }

    it 'creates the example' do
      described_class.create(path: path)
      script_path = Pathname.new(File.join(examples_path, script_name))
      expect(script_path).to be_executable
    end
  end
end
