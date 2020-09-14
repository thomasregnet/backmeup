# frozen_string_literal: true

RSpec.shared_examples 'a scriptable action' do
  describe 'methods the mixin defines' do
    it { should respond_to(:perform) }
  end
end
