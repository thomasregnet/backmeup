# frozen_string_literal: true

require 'tty-command'

module Backmeup
  # Create a Backup-Destination
  class CreateDestinationAction < ActionBase
    def self.perform(args)
      new(**args).perform
    end

    def initialize(destination:, previous_destination:, **args)
      super(**args)
      @destination          = destination
      @previous_destination = previous_destination
    end

    attr_reader :destination, :previous_destination, :root

    def perform
      if script_exists?
        cmd.run(script_pathname.to_s)
      else
        destination_path.mkpath
      end

      FurnishDestinationAction.perform(layout: destination_layout, root: root)
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
  end
end
