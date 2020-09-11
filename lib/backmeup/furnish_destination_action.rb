# frozen_string_literal: true

module Backmeup
  # Create the structure of a destination
  class FurnishDestinationAction < ActionBase
    def self.perform(args)
      new(**args).perform
    end

    def initialize(layout:)
      @layout = layout
    end

    attr_reader :layout

    def perform
      FileUtils.mkpath(layout.data)
      File.open(layout.stderr, 'w') { |file| file.truncate(0) }
      File.open(layout.stdout, 'w') { |file| file.truncate(0) }
    end
  end
end
