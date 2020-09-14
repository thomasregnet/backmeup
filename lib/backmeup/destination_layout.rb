# frozen_string_literal: true

module Backmeup
  # Paths inside a destination
  module DestinationLayout
    def destination_data
      @destination_data ||= File.join(destination_path, 'data')
    end

    def destination_path
      @destination_path ||= File.join(root.backups, destination)
    end

    def destination_stderr
      @destination_stderr ||= File.join(destination_path, 'stderr')
    end

    def destination_stdout
      @destination_stdout ||= File.join(destination_path, 'stdout')
    end
  end
end
