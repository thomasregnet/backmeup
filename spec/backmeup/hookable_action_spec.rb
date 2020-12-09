# frozen_string_literal: true

module TestBackmeup
  # For testing only
  class WithHooks
    prepend Backmeup::HookableAction

    def perform
      @performed = true
    end

    attr_reader :performed

    def performed?
      performed
    end

    def env
      :fake_env
    end

    def root
      :fake_root
    end

    def script_name
      'test_script'
    end
  end
end

RSpec.describe Backmeup::HookableAction do
  let(:hookable) { TestBackmeup::WithHooks.new }

  before do
    allow(Backmeup::ScriptIfExist).to receive(:run)
      .with(env: :fake_env, root: :fake_root, script_name: 'before_test_script')

    allow(Backmeup::ScriptIfExist).to receive(:run)
      .with(env: :fake_env, root: :fake_root, script_name: 'after_test_script')
  end

  it 'calls #perform' do
    hookable.perform
    expect(hookable).to be_performed
  end

  it 'calls the hooks' do
    hookable.perform
    expect(Backmeup::ScriptIfExist).to have_received(:run).twice
  end
end
