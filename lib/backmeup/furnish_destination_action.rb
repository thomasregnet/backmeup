# frozen_string_literal: true

module Backmeup
  # Create the structure of a destination
  class FurnishDestinationAction < ActionBase
    def self.perform(args)
      new(**args).perform
    end

    def initialize(layout:, **args)
      super(**args)
      @layout = layout
    end

    attr_reader :layout

    def perform
      FileUtils.mkpath(layout.data)
      create_or_empty(layout.stderr)
      create_or_empty(layout.stdout)
    end

    private

    def create_or_empty(path)
      File.open(path, 'w') { |file| file.truncate(0) }
    end
  end
end
