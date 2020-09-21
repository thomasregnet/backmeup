# frozen_string_literal: true

RSpec.describe Backmeup::Root do
  let(:root) { described_class.new('my_backups') }

  describe '#backups' do
    it 'returns the backups' do
      expect(root.backups.to_s).to eq(File.join('my_backups', 'backups'))
    end
  end
end
