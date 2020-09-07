# frozen_string_literal: true

RSpec.describe Backmeup::ActionBase do
  subject { described_class.new(root: :fake_root) }

  it { should respond_to(:root) }

  describe '#cmd' do
    it 'returns an instance of TTY::Command' do
      expect(subject.send(:cmd)).to be_instance_of(TTY::Command)
    end
  end

  describe '#script_name' do
    before do
      allow(subject).to receive(:class).and_return('Backmeup::SomeThingAction')
    end

    it 'returns the name of the script' do
      expect(subject.send(:script_name)).to eq('some_thing')
    end
  end
end
