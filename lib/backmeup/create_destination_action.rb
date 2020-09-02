# frozen_string_literal: true

module Backmeup
  # Create a Backup-Destination
  class CreateDestinationAction
    def self.perform(args)
      new(**args).perform
    end

    def initialize(backups_dir:, destination:)
      @backups_dir = backups_dir
      @destination = destination
    end

    attr_reader :backups_dir, :destination

    def perform
      destination_path = File.join(backups_dir, destination)
      FileUtils.mkpath(destination_path)
    end
  end
end
