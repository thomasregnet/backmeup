# frozen_string_literal: true

require 'tty-command'

module Backmeup
  # Create a Backup-Destination
  class CreateDestinationAction < ActionBase
    include DestinationLayout
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
      env = {
        'DESTINATION_PATH'          => destination_path,
        'PREVIOUS_DESTINATION_PATH' => previous_destination
      }
      cmd.run(script_path, env: env)
      furnish_destination
    end

    def perform_without_script
      FileUtils.mkpath(destination_path)
      furnish_destination
    end

    private

    def furnish_destination
      FurnishDestinationAction.perform(destination: destination, root: root)
    end
  end
end
