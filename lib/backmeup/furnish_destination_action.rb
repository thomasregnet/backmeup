# frozen_string_literal: true

module Backmeup
  # Create the structure of a destination
  class FurnishDestinationAction < ActionBase
    def self.perform(args)
      new(**args).perform
    end

    def initialize(destination_path:)
      @destination_path = destination_path
    end

    attr_reader :destination_path

    def perform
      create_destination_data
      create_destination_log('stdout')
      create_destination_log('stderr')
    end

    private

    def create_destination_data
      FileUtils.mkpath(File.join(destination_path, 'data'))
    end

    def create_destination_log(file_name)
      log_file = File.join(destination_path, file_name)
      File.open(log_file, 'w') { |file| file.truncate(0) }
    end
  end
end
