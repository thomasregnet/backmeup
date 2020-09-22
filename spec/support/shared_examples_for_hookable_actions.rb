# frozen_string_literal: true

RSpec.shared_examples 'a hookable action' do
  it { is_expected.to respond_to(:perform) }
  it { is_expected.to respond_to(:root) }

  describe '#cmd' do
    it 'returns an instance of TTY::Command' do
      expect(subject.send(:cmd)).to be_instance_of(TTY::Command)
    end
  end

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

  %w[before after].each do |point|
    describe "#{point} hook" do
      let(:perform) { subject.method(:perform) }
      let(:cmd) { spy }
      let(:bin_path) { File.join(subject.root.base_path, 'bin') }

      before do
        FileUtils.mkpath(bin_path)
        allow(subject).to receive(:perform_without_script)
      end

      after { FileUtils.rm_rf(bin_path) }

      context "when a #{point} hook exist?" do
        before do
          hook_name = "#{point}_#{script_name}"
          hook_path = File.join(bin_path, hook_name)

          FileUtils.touch(hook_path)
          FileUtils.chmod(0o755, hook_path)

          allow(TTY::Command).to receive(:new).and_return(cmd)
          allow(cmd).to receive(:run)
        end

        it 'calls #perform_with_script' do
          subject.perform
          expect(cmd).to have_received(:run)
        end
      end

      context 'when no before hook exist?' do
        it 'calls #perform_without_script' do
          subject.perform
          expect(cmd).not_to have_received(:run)
        end
      end
    end
  end
end
