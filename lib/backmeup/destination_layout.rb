# frozen_string_literal: true

module Backmeup
  # Paths inside a destination
  module DestinationLayout
    def destination_data
      @data ||= File.join(root.backups, destination, 'data')
    end

    def destination_path
      @destination_path ||= File.join(root.backups, destination)
    end

    def destination_stderr
      @stderr ||= File.join(root.backups, destination, 'stderr')
    end

    def destination_stdout
      @stdout ||= File.join(root.backups, destination, 'stdout')
    end
  end
end
