# frozen_string_literal: true

require 'tty-command'

module Backmeup
  # Create a backup
  class CreateBackupAction < ActionBase
    include ScriptableAction

    def self.perform(args)
      new(**args).perform
    end

    def initialize(destination:, previous_destination:, **args)
      super(**args)
      @destination          = destination
      @previous_destination = previous_destination
    end

    attr_reader :destination, :previous_destination, :root

    protected

    def perform_with_script
      cmd.run(script_path)
    end

    def perform_without_script
      File.open(File.join(root.config, 'filelist')).each do |src|
        FileUtils.cp_r(src.chomp, backup_destination)
      end
    end

    private

    def backup_destination
      @backup_destination ||= File.join(root.backups, destination, 'data')
    end
  end
end
