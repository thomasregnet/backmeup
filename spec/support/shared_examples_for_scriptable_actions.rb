# frozen_string_literal: true

RSpec.shared_examples 'a scriptable action' do
  it { should respond_to(:perform) }

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
end
