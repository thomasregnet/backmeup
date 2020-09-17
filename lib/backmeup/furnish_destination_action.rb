# frozen_string_literal: true

module Backmeup
  # Create the structure of a destination
  class FurnishDestinationAction < ActionBase
    include ScriptableAction
    include DestinationLayout

    def self.perform(args)
      new(**args).perform
    end

    def initialize(destination:, **args)
      super(**args)
      @destination = destination
    end

    attr_reader :destination

    protected

    def env
      {
        'DESTINATION_DATA' => destination_data,
        'DESTINATION_PATH' => destination_path,
        'DESTINATION_STDERR' => destination_stderr,
        'DESTINATION_STDOUT' => destination_stdout
      }
    end

    def perform_without_script
      FileUtils.mkpath(destination_data)
      create_or_empty(destination_stderr)
      create_or_empty(destination_stdout)
    end

    private

    def create_or_empty(path)
      File.open(path, 'w') { |file| file.truncate(0) }
    end
  end
end
