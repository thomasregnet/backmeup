# frozen_string_literal: true

require 'tty-command'

module Backmeup
  # Create a Backup-Destination
  class CreateDestinationAction
    def self.perform(args)
      new(**args).perform
    end

    def initialize(destination:, root:)
      @destination = destination
      @root        = root
    end

    attr_reader :destination, :root

    def perform
      destination_path = Pathname.new(File.join(root.backups, destination))
      if script_exists?
        cmd.run(script_pathname.to_s)
      else
        destination_path.mkpath
      end
    end

    def cmd
      TTY::Command.new
    end

    def script_exists?
      root.bin.glob(script_name)[0] ? true : false
    end

    def script_path
      script_pathname.to_s
    end

    def script_pathname
      @script_pathname ||= Pathname.new(File.join(root.bin, script_name))
    end

    def script_name
      match = self.class.to_s.match(/\A.*::(.+)Action\z/) || return
      match[1].underscore
    end
  end
end
