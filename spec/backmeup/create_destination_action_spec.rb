# frozen_string_literal: true

require 'support/shared_examples_for_actions'

RSpec.describe Backmeup::CreateDestinationAction do
  it_behaves_like 'an action'

  describe '.perform' do
    let(:root) { Backmeup::Root.new('tmp') }
    let(:destination_date) { DateTime.now.to_s }

    context 'without a create_destination script' do
      before { FileUtils.mkpath(File.join('tmp', 'backups')) }

      after { FileUtils.rm_rf(File.join('tmp', 'backups')) }

      it 'creates the destination' do
        described_class.perform(
          destination: destination_date,
          root:        root
        )

        expect(Pathname.new(File.join('tmp', 'backups', destination_date)))
          .to exist
      end
    end

    context 'with a create_destination script' do
      let(:creator) do
        described_class.new(
          destination: destination_date,
          root:        root
        )
      end

      let(:bin_path) { File.join('tmp', 'bin') }
      let(:cmd) { instance_double('TTY::Command') }

      before do
        FileUtils.mkpath(bin_path)
        script_path = File.join(bin_path, 'create_destination')
        FileUtils.touch(script_path)
        FileUtils.chmod(0o755, script_path)

        allow(creator).to receive(:cmd).and_return(cmd)
        allow(cmd).to receive(:run)
      end

      after { FileUtils.rm_rf(bin_path) }

      it 'calls cmd.run' do
        creator.perform
        expect(cmd).to have_received(:run)
      end
    end
  end
end
