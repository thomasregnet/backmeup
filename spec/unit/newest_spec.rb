# frozen_string_literal: true

require 'backmeup/commands/newest'

RSpec.describe Backmeup::Commands::Newest do
  let(:backups) { File.join(repository, 'backups') }
  let(:command) { described_class.new(backups, {}) }
  let(:newest_backup) { File.join(backups, '2020-12-12T11:12:13+02:00') }
  let(:output) { StringIO.new }
  let(:repository) { 'tmp' }

  before do
    FileUtils.mkpath(backups)
  end

  after { FileUtils.rm_rf(backups) }

  context 'without backups' do
    it 'produces no output' do
      command.execute(output: output)
      expect(output.string).to eq('')
    end
  end

  context 'with one backup' do
    before { FileUtils.mkpath(newest_backup) }

    it 'prints that backup' do
      command.execute(output: output)
      expect(output.string).to eq("#{newest_backup}\n")
    end
  end

  context 'with many backups' do
    before do
      (10..12).each do |day|
        backup = File.join(backups, "2020-12-#{day}T11:12:13+02:00")
        FileUtils.mkpath(backup)
      end

      FileUtils.mkpath(newest_backup)
    end

    it 'prints that backup' do
      command.execute(output: output)
      expect(output.string).to eq("#{newest_backup}\n")
    end
  end
end
