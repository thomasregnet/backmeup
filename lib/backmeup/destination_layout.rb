# frozen_string_literal: true

module Backmeup
  # Paths inside a destination
  class DestinationLayout
    def initialize(destination:, root:)
      @destination = destination
      @root        = root
    end

    attr_reader :destination, :root

    def data
      @data ||= File.join(root.backups, destination, 'data')
    end

    def stderr
      @stderr ||= File.join(root.backups, destination, 'stderr')
    end

    def stdout
      @stdout ||= File.join(root.backups, destination, 'stdout')
    end
  end
end
