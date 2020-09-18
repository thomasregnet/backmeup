# frozen_string_literal: true

require 'tty-command'

module Backmeup
  # Create a Backup-Destination
  class CreateDestinationAction < ActionBase
    include DestinationLayout
    include PreviousDestinationLayout
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

    def env
      previous_destination_env({ 'DESTINATION_PATH' => destination_path })
    end

    def perform_with_script
      super
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

    # TODO: delete method?
    def previous_destination_path
      return unless previous_destination

      File.join(root.backups, previous_destination)
    end
  end
end
