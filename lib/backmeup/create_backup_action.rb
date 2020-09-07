# frozen_string_literal: true

module Backmeup
  # Create a backup
  class CreateBackupAction
    def self.perform(args)
      new(**args).perform
    end

    def initialize(destination:, previous_destination:, root:)
      @destination          = destination
      @previous_destination = previous_destination
      @root                 = root
    end

    attr_reader :destination, :previous_destination, :root

    def perform
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
