# frozen_string_literal: true

require 'support/shared_examples_for_actions'

RSpec.describe Backmeup::CreateDestinationAction do
  it_behaves_like 'an action'

  describe '.perform' do
    context 'without a create_destination script' do
      let(:root) { Backmeup::Root.new('tmp') }
      let(:destination_date) { DateTime.now.to_s }

      # before { FileUtils.mkpath(backups_dir) }
      before { FileUtils.mkpath(File.join('tmp', 'backups')) }
      # after { FileUtils.rm_rf(backups_dir) }

      it 'creates the destination' do
        described_class.perform(
          destination: destination_date,
          root:        root
        )

        expect(Pathname.new(File.join('tmp', 'backups', destination_date))).to exist
      end
    end
  end
end
