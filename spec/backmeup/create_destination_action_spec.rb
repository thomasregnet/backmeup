# frozen_string_literal: true

require 'support/shared_examples_for_actions'

RSpec.describe Backmeup::CreateDestinationAction do
  it_behaves_like 'an action'

  describe '.perform' do
    context 'without a create_destination script' do
      let(:backups_dir) { File.join('tmp', 'backups') }
      let(:destination_date) { DateTime.now.to_s }

      before { FileUtils.mkpath(backups_dir) }

      after { FileUtils.rm_rf(backups_dir) }

      it 'creates the destination' do
        described_class.perform(
          backups_dir: backups_dir,
          destination: destination_date
        )

        expect(Pathname.new(File.join(backups_dir, destination_date))).to exist
      end
    end
  end
end
