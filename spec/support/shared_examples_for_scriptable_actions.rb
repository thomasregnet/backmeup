# frozen_string_literal: true

RSpec.shared_examples 'a scriptable action' do
  it { is_expected.to respond_to(:perform) }

  describe '#perform' do
    context 'when a script exists' do
      before do
        allow(subject).to receive('script_exists?').and_return(true)
        allow(subject).to receive(:perform_with_script)
      end

      it 'calls #perform_with_script' do
        subject.perform
        expect(subject).to have_received(:perform_with_script)
      end
    end

    context 'when no script exists' do
      before do
        allow(subject).to receive('script_exists?').and_return(false)
        allow(subject).to receive(:perform_without_script)
      end

      it 'calls #perform_without_script' do
        subject.perform
        expect(subject).to have_received(:perform_without_script)
      end
    end
  end

  describe '#cmd (protected)' do
    it 'returns an instance of TTY::Command' do
      expect(subject.send(:cmd)).to be_instance_of(TTY::Command)
    end
  end

  describe '#env (protected)' do
    it 'returns a hash' do
      expect(subject.send(:env)).to be_instance_of(Hash)
    end
  end

  describe '#script_name' do
    it 'returns the expected script_name' do
      expect(subject.send(:script_name)).to eq(script_name)
    end
  end
end
