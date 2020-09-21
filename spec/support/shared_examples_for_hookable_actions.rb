# frozen_string_literal: true

RSpec.shared_examples 'a hookable action' do
  it { should respond_to(:perform) }
  it { should respond_to(:root) }

  describe '#cmd' do
    it 'returns an instance of TTY::Command' do
      expect(subject.send(:cmd)).to be_instance_of(TTY::Command)
    end
  end

  describe '#script_name' do
    it 'returns the script name as String' do
      expect(subject.send(:script_name)).to be_instance_of(String)
    end
  end

  describe 'before hook' do
    context 'when a before hook exist?' do
      let(:cmd) { instance_double('TTY::Command') }

      before do
        allow(subject).to receive('before_hook_exist?').and_return(true)
        allow(subject).to receive(:perform_without_script)
        allow(subject).to receive(:cmd).and_return(cmd)
        allow(cmd).to receive(:run)
      end

      it 'calls #perform_with_script' do
        subject.perform
        expect(cmd).to have_received(:run)
      end
    end

    context 'when no before hook exist?' do
      before do
        allow(subject).to receive('before_hook_exist?').and_return(false)
        allow(subject).to receive(:perform_without_script)
        allow(subject).to receive(:perform_without_script)
      end

      it 'calls #perform_without_script' do
        subject.perform
        expect(subject).to have_received(:perform_without_script)
      end
    end
  end

  describe 'after hook' do
    context 'when a after hook exist?' do
      let(:cmd) { instance_double('TTY::Command') }

      before do
        allow(subject).to receive('after_hook_exist?').and_return(true)
        allow(subject).to receive(:perform_without_script)
        allow(subject).to receive(:cmd).and_return(cmd)
        allow(cmd).to receive(:run)
      end

      it 'calls #perform_with_script' do
        subject.perform
        expect(cmd).to have_received(:run)
      end
    end

    context 'when no after hook exist?' do
      before do
        allow(subject).to receive('after_hook_exist?').and_return(false)
        allow(subject).to receive(:perform_without_script)
        allow(subject).to receive(:perform_without_script)
      end

      it 'calls #perform_without_script' do
        subject.perform
        expect(subject).to have_received(:perform_without_script)
      end
    end
  end
end
