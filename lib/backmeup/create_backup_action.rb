# frozen_string_literal: true

require 'tty-command'

module Backmeup
  # Create a backup
  class CreateBackupAction < ActionBase
    include DestinationLayout
    include PreviousDestinationLayout
    include ScriptableAction
    prepend HookableAction

    def self.perform(args)
      new(**args).perform
    end

    def initialize(destination:, previous_destination:, **args)
      super(**args)
      @destination          = destination
      @previous_destination = previous_destination
    end

    attr_reader :destination, :previous_destination

    protected

    def env
      destination_env(previous_destination_env).merge(config_env)
    end

    def perform_without_script
      File.open(File.join(root.config, 'filelist')).each do |src|
        FileUtils.cp_r(src.chomp, backup_destination)
      end
    end

    private

    def config_env
      result = {}
      files_pathname = Pathname.new(File.join(root.config, 'files'))
      excludes_pathname = Pathname.new(File.join(root.config, 'excludes'))

      result['FILES_PATH']    = files_pathname.to_s    if files_pathname.exist?
      result['EXCLUDES_PATH'] = excludes_pathname.to_s if excludes_pathname.exist?

      result
    end

    def backup_destination
      @backup_destination ||= File.join(root.backups, destination, 'data')
    end
  end
end
