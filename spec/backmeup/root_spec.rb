# frozen_string_literal: true

RSpec.describe Backmeup::Root do
  subject { described_class.new('my_backups') }

  describe '#backups' do
    it 'returns the backups' do
      expect(subject.backups.to_s).to eq(File.join('my_backups', 'backups'))
    end
  end
end
