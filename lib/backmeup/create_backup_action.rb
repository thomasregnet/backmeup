# frozen_string_literal: true

require 'tty-command'

module Backmeup
  # Create a backup
  class CreateBackupAction < ActionBase
    def self.perform(args)
      new(**args).perform
    end

    def initialize(destination:, previous_destination:, **args)
      super(args)
      @destination          = destination
      @previous_destination = previous_destination
    end

    attr_reader :destination, :previous_destination, :root

    def perform
      if script_exists?
        cmd.run(script_pathname.to_s)
      else
        File.open(File.join(root.config, 'filelist')).each do |src|
          FileUtils.cp_r(src.chomp, backup_destination)
        end
      end
    end

    private

    def backup_destination
      @backup_destination ||= File.join(root.backups, destination, 'data')
    end
  end
end
