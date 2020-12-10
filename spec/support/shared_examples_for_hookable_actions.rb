# frozen_string_literal: true

RSpec.shared_examples 'a hookable action' do
  it { is_expected.to respond_to(:perform) }
  it { is_expected.to respond_to(:root) }

  # the method #env may be protected so we use #send(:env)
  describe '#env' do
    it 'returns a hash' do
      expect(subject.send(:env)).to be_instance_of(Hash)
    end
  end

  # the mehod #script_name may be protected so we use #send(:script_name)
  describe '#script_name' do
    it 'returns the script name as String' do
      expect(subject.send(:script_name)).to be_instance_of(String)
    end
  end
end
