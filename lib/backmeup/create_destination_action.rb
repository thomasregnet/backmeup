# frozen_string_literal: true

require 'tty-command'

module Backmeup
  # Create a Backup-Destination
  class CreateDestinationAction < ActionBase
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

    def perform_with_script
      cmd.run(script_pathname.to_s)
      furnish_destination
    end

    def perform_without_script
      destination_path.mkpath
      furnish_destination
    end

    private

    def destination_layout
      @destination_layout ||= DestinationLayout.new(
        destination: destination,
        root: root
      )
    end

    def destination_path
      @destination_path ||= Pathname.new(File.join(root.backups, destination))
    end

    def furnish_destination
      FurnishDestinationAction.perform(destination: destination, root: root)
    end
  end
end
