# frozen_string_literal: true

module TestBackmeup
  # For testing only
  class WithHooks
    prepend Backmeup::HookableAction

    def perform; end

    def env
      {}
    end

    def root
      @root ||= Backmeup::Root.new('tmp')
    end

    def script_name
      'test_script'
    end
  end
end

RSpec.describe Backmeup::HookableAction do
  let(:hookable) { TestBackmeup::WithHooks.new }

  %w[before after].each do |point|
    describe "#{point} hook" do
      let(:cmd) { spy }
      let(:bin_path) { File.join(hookable.root.base_path, 'bin') }

      before do
        FileUtils.mkpath(bin_path)
      end

      after { FileUtils.rm_rf(bin_path) }

      context "when a #{point} hook exist?" do
        before do
          hook_name = "#{point}_#{hookable.script_name}"
          hook_path = File.join(bin_path, hook_name)

          FileUtils.touch(hook_path)
          FileUtils.chmod(0o755, hook_path)

          allow(TTY::Command).to receive(:new).and_return(cmd)
          result = spy
          allow(cmd).to receive(:run).and_return(result)
          allow(result).to receive(:status).and_return(0)
        end

        it 'calls the before hook' do
          hookable.perform
          expect(cmd).to have_received(:run)
        end
      end

      context 'when no before hook exist?' do
        it 'calls does not call run on TTY::command' do
          hookable.perform
          expect(cmd).not_to have_received(:run)
        end
      end
    end
  end
end
