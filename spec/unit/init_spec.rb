# frozen_string_literal: true

require 'backmeup/commands/init'

RSpec.describe Backmeup::Commands::Init do
  describe '#execute' do
    let(:options) { {} }
    let(:output) { StringIO.new }
    let(:path) { Pathname.new(File.join('tmp', 'my_backups')) }

    before do
      Backmeup::Commands::Init.new(path, options).execute(output: output)
    end

    after do
      FileUtils.rm_rf(path)
    end

    it 'creates the main directory' do
      expect(path).to be_exist
    end

    it 'creates the "backups" directory' do
      backups_path = Pathname(File.join(path, 'backups'))
      expect(backups_path).to be_exist
    end

    it 'creates the "bin" directory' do
      bin_path = Pathname(File.join(path, 'bin'))
      expect(bin_path).to be_exist
    end

    it 'creates the "config" directory' do
      config_path = Pathname(File.join(path, 'config'))
      expect(config_path).to be_exist
    end

    it 'prints out the expected message' do
      expect(output.string).to eq("created tmp/my_backups\n")
    end
  end
end
