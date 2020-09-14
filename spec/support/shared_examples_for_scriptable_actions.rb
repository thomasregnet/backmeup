# frozen_string_literal: true

RSpec.shared_examples 'a scriptable action' do
  describe 'methods the including class must define' do
    it { should respond_to(:perform_with_script) }
    it { should respond_to(:perform_without_script) }
  end

  describe 'methods the mixin defines' do
    it { should respond_to(:perform) }
  end
end
