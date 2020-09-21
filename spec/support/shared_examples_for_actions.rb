# frozen_string_literal: true

RSpec.shared_examples 'an action' do
  describe '.perform' do
    it 'responds to .perform' do
      expect(described_class).to respond_to(:perform)
    end
  end
end
