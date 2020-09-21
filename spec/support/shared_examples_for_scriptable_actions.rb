# frozen_string_literal: true

RSpec.shared_examples 'a scriptable action' do
  it { is_expected.to respond_to(:perform) }

  describe '#perform' do
    # We allow RSpec/SubjectStub because we want to ensure
    # that the expected method is called.
    # We're not interested in the method itself.
    # rubocop:disable RSpec/SubjectStub
    context 'when a script exists' do
      before do
        FileUtils.mkpath(subject.root.bin)
        script_path = File.join(subject.root.bin, script_name)
        FileUtils.touch(script_path)
        FileUtils.chmod(0o755, script_path)
        allow(subject).to receive(:perform_with_script)
      end

      after { FileUtils.rm_rf(File.join(subject.root.bin)) }

      it 'calls #perform_with_script' do
        subject.perform
        expect(subject).to have_received(:perform_with_script)
      end
    end

    context 'when no script exists' do
      before do
        allow(subject).to receive(:perform_without_script)
      end

      it 'calls #perform_without_script' do
        subject.perform
        expect(subject).to have_received(:perform_without_script)
      end
    end
    # rubocop:enable RSpec/SubjectStub
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
