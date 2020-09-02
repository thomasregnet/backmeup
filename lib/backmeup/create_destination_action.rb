# frozen_string_literal: true

module Backmeup
  # Create a Backup-Destination
  class CreateDestinationAction
    def self.perform(args)
      new(**args).perform
    end

    def initialize(destination:, root:)
      @destination = destination
      @root        = root
    end

    attr_reader :destination, :root

    def perform
      destination_path = Pathname.new(File.join(root.backups, destination))
      destination_path.mkpath
    end
  end
end
