# frozen_string_literal: true

require 'tty-command'

module Backmeup
  # Create a backup
  class CreateBackupAction
    def self.perform(args)
      new(**args).perform
    end

    def initialize(destination:, previous_destination:, root:)
      @destination          = destination
      @previous_destination = previous_destination
      @root                 = root
    end

    attr_reader :destination, :previous_destination, :root

    def perform
      if script_exists?
        cmd.run(script_pathname.to_s)
      else
        File.open(File.join(root.config, 'filelist')).each do |src|
          FileUtils.cp_r(src.chomp, backup_destination)
        end
      end
    end

    private

    def backup_destination
      @backup_destination ||= File.join(root.backups, destination, 'data')
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
