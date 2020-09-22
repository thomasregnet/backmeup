# frozen_string_literal: true

RSpec.shared_examples 'a hookable action' do
  it { is_expected.to respond_to(:perform) }
  it { is_expected.to respond_to(:root) }

  # describe '#cmd' do
  #   it 'returns an instance of TTY::Command' do
  #     expect(subject.send(:cmd)).to be_instance_of(TTY::Command)
  #   end
  # end

  describe '#env' do
    it 'returns a hash' do
      expect(subject.send(:env)).to be_instance_of(Hash)
    end
  end

  describe '#script_name' do
    it 'returns the script name as String' do
      expect(subject.send(:script_name)).to be_instance_of(String)
    end
  end
end
